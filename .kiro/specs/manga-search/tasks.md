# Implementation Plan: Manga Search

## Overview

This plan implements the Manga Search feature incrementally, starting with the Vietnamese string foundation, then the client network operation, the `SearchProvider` state layer, the backend endpoint extension, the contract-verification reference model with property tests, the search UI widgets, the `SearchScreen` assembly, and finally the routing/provider wiring that connects everything to the existing `/search` route.

Property-based tests use the Dart `glados` package (added under `dev_dependencies`), run a minimum of 100 generated examples each, and are tagged with a comment of the form `// Feature: manga-search, Property {number}: {property_text}`. Each property test maps to exactly one correctness property from the design.

The backend (Requirements 1–3) lives in the separate `prm-backend` Spring Boot repository; those tasks specify the contract and filter/pagination semantics the client depends on. The client-side reference model (task 6) validates that contract with property tests inside this workspace, mirroring what the backend repo asserts with its own JVM property tests.

## Tasks

- [ ] 1. Extend Vietnamese strings for the search screen
  - [ ] 1.1 Add search input/label/result string constants and the result-count formatter to `AppStringsVi`
    - In `lib/core/constants/app_strings_vi.dart`, extend the existing SEARCH SCREEN group with `searchByTitleHint`, `searchByCreatorLabel`, `searchByCreatorHint`, `searchByTagLabel`, `searchByTagHint`, `searchSubmit`, `searchClear`
    - Add a static formatter `String searchResultCount(int count) => 'Tìm thấy $count truyện';`
    - Add a static formatter `String searchPageIndicator(int current, int total) => 'Trang $current/$total';`
    - Reuse existing `noResults`, `errorGeneric`, `tryAgain`, `previous`, `next`, `loading`
    - _Requirements: 6.8, 7.2, 7.4_

  - [ ]* 1.2 Write property test for the result-count formatter
    - **Property 11: Result count phrase formats the count**
    - **Validates: Requirements 7.2**
    - Generate non-negative counts and assert output equals `'Tìm thấy {count} truyện'` with the count substituted

- [ ] 2. Implement the search request in `MangaApiService`
  - [ ] 2.1 Add `buildSearchQuery` helper and `searchMangas` operation
    - In `lib/data/network/manga_api_service.dart`, add a `@visibleForTesting Map<String, dynamic> buildSearchQuery({String? keyword, String? creatorId, List<String>? tagIds, int page = 0, int size = 20})` that always includes `page` and `size`, includes `q` only for a non-blank trimmed keyword, `creatorId` only when non-empty, and `tagId` (list) only when non-empty
    - Add `Future<PaginatedManga> searchMangas({...})` that builds params via the helper, GETs `dio.options.baseUrl.replaceAll('/api/v1', '/api/mangas')`, parses the Spring `Page` shape into `PaginatedManga`, and returns an empty `PaginatedManga` when `data` is null
    - Rely on the existing `ApiService` `onError` interceptor to normalize Dio failures into `ApiException`
    - _Requirements: 4.1, 4.2, 4.3, 4.4, 4.5, 4.6_

  - [ ]* 2.2 Write property test for `buildSearchQuery`
    - **Property 6: Query builder includes exactly the supplied criteria**
    - **Validates: Requirements 4.2, 4.3, 4.4**
    - Generate optional keyword/creator/tag combinations plus page/size; assert presence/absence of `q`, `creatorId`, `tagId` matches the supplied criteria and `page`/`size` are always present

  - [ ]* 2.3 Write unit tests for `searchMangas` parsing and error path
    - Null `data` → empty `PaginatedManga`; out-of-range page → empty content; simulated Dio error surfaces a non-empty `ApiException` message
    - _Requirements: 4.5, 4.6, 3.4_

- [ ] 3. Implement `SearchProvider` state management
  - [ ] 3.1 Create `SearchProvider` with criteria, results, pagination, and status
    - Create `lib/providers/search_provider.dart` as a `ChangeNotifier` constructed with `MangaApiService`, holding `keyword`, `creator`, `tags`, `results`, `resultCount`, 0-based `currentPage` (exposed 1-based), `totalPages`, `pageSize`, and `SearchStatus`
    - Implement `setKeyword`/`setCreator`/`setTags` mutators, `submitSearch()` (always page 0), `goToPage`/`nextPage`/`previousPage` (clamped to `[1, totalPages]`, criteria unchanged), `retry()`, and `clear()`
    - Expose `isLoading`, `errorMessage`, `hasPreviousPage`, `hasNextPage`, `hasMultiplePages`; map success to `success`/`empty`, catch `ApiException` to set `error`
    - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5, 5.6, 5.7_

  - [ ]* 3.2 Write property test for response-to-state mapping
    - **Property 7: Successful search maps the response into provider state**
    - **Validates: Requirements 4.5, 5.4**
    - Using a fake `MangaApiService` returning generated `Page` payloads, assert results equal parsed content, `resultCount == totalElements`, `totalPages` matches, and current page corresponds to `number`

  - [ ]* 3.3 Write property test for `clear()`
    - **Property 8: Clearing criteria resets to empty state**
    - **Validates: Requirements 5.6**
    - From generated arbitrary provider states, assert after `clear()` keyword is empty, creator unset, tags empty, results empty, and `resultCount == 0`

  - [ ]* 3.4 Write property test for pagination control enablement
    - **Property 9: Pagination control enablement matches page position**
    - **Validates: Requirements 8.4, 8.5**
    - Over generated `(currentPage, totalPages)` pairs, assert `hasPreviousPage` iff current > 1 and `hasNextPage` iff current < totalPages

  - [ ]* 3.5 Write property test for navigation preserving criteria
    - **Property 10: Page navigation preserves criteria and surfaces the requested page**
    - **Validates: Requirements 5.7, 8.2, 8.3, 8.6**
    - Using a recording fake `MangaApiService`, assert next/previous/goToPage issue requests with unchanged criteria and the target page index, and the displayed results are those returned for that page

  - [ ]* 3.6 Write unit tests for `submitSearch`, loading, and failure behavior
    - `submitSearch` requests page 0 with current criteria; `isLoading` true while pending; failure sets the error message
    - _Requirements: 5.2, 5.3, 5.5_

- [ ] 4. Checkpoint - Ensure data, service, and state layers pass
  - Ensure all tests pass, ask the user if questions arise.

- [ ] 5. Extend the backend `Manga_Query_Endpoint` (in the separate `prm-backend` repo)
  - [ ] 5.1 Add keyword and creator filters combined with the existing tag filter
    - Extend `GET /api/mangas/` to accept optional `q` (title/slug/description match), optional `creatorId` (author OR artist contains the id), and repeatable `tagId` (results must match every supplied tag, AND semantics); combine all supplied criteria with AND; return the unfiltered list when none supplied
    - Return a Spring `Page<MangaResponseDTO>` inside `BaseApiResponse` with content, totalElements, totalPages, number, size, first, last, numberOfElements, empty; default `page=0`, `size=20`; empty content with `empty=true` when page index ≥ totalPages
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 3.1_

  - [ ] 5.2 Validate pagination parameters and edge-case creator filter
    - Return a `BaseApiResponse` with null data and a descriptive error field for a negative page index or a size less than 1; return empty content with `totalElements == 0` for an unknown creator id
    - _Requirements: 3.2, 3.3, 3.4_

- [ ] 6. Build the client-side contract reference model and backend-contract property tests
  - [ ] 6.1 Implement a pure Dart reference filter and pagination model mirroring the endpoint contract
    - Create a test-support module (e.g. `test/support/manga_search_reference.dart`) that, given a manga dataset and optional keyword/creator/tag criteria, returns the matching set (AND semantics), slices it by page index/size, computes `totalElements`, and reports an invalid-pagination error for negative page or size < 1
    - _Requirements: 1.1, 1.2, 1.3, 1.4, 1.5, 2.2, 2.3, 2.6, 2.7, 3.2, 3.3, 3.4_

  - [ ]* 6.2 Write property test for the combined-criteria filter
    - **Property 1: Combined criteria filter returns only fully matching manga**
    - **Validates: Requirements 1.1, 1.2, 1.3, 1.4**
    - Over generated datasets and optional criteria, assert every returned manga satisfies all supplied criteria simultaneously

  - [ ]* 6.3 Write property test for the page-size bound
    - **Property 2: Page content never exceeds Page_Size**
    - **Validates: Requirements 2.3**
    - Over generated datasets, page indices, and sizes (≥ 1), assert returned content length ≤ size

  - [ ]* 6.4 Write property test for page slicing
    - **Property 3: Page slicing returns the correct page**
    - **Validates: Requirements 2.2**
    - Assert returned content equals the ordered match-set slice starting at `pageIndex * size` spanning at most `size` elements

  - [ ]* 6.5 Write property test for total-count invariance
    - **Property 4: Total count is invariant across pages**
    - **Validates: Requirements 2.6**
    - Assert `totalElements` equals the full match count and is identical regardless of requested page index

  - [ ]* 6.6 Write property test for invalid pagination
    - **Property 5: Invalid pagination parameters produce an error envelope**
    - **Validates: Requirements 3.2, 3.3**
    - Over generated negative page indices and sub-1 sizes, assert a null-data response with a non-null error describing the invalid parameter

- [ ] 7. Build the search input and pagination widgets
  - [ ] 7.1 Implement the `CreatorSelector` widget
    - Create `lib/presentation/screens/search/widgets/creator_selector.dart` backed by `CreatorProvider`, opening a searchable picker; selecting calls `provider.setCreator(creator)`; labels/hints from `AppStringsVi`
    - _Requirements: 6.2, 6.8_

  - [ ] 7.2 Implement the `TagSelector` widget
    - Create `lib/presentation/screens/search/widgets/tag_selector.dart` backed by `TagProvider` as multi-select chips updating `provider.setTags(tags)`; labels/hints from `AppStringsVi`
    - _Requirements: 6.3, 6.8_

  - [ ] 7.3 Implement the `SearchPaginationControls` widget
    - Create `lib/presentation/screens/search/widgets/search_pagination_controls.dart` showing previous/next controls and `Trang {current}/{total}`; previous calls `previousPage()` and is disabled at page 1, next calls `nextPage()` and is disabled at the last page; rendered only when `hasMultiplePages`
    - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

- [ ] 8. Assemble the `SearchScreen`
  - [ ] 8.1 Implement `SearchScreen` with controls, status-driven results, and pagination
    - Create `lib/presentation/screens/search/search_screen.dart` with the brutalism-styled scaffold, a debounced `Title_Keyword` `TextField` (injectable `Debounce_Interval`, default 400ms; zero fires synchronously on edit), the `CreatorSelector`, `TagSelector`, submit (`submitSearch`) and clear (`clear`) controls
    - Render results by `SearchStatus`: loading spinner; success with `AppStringsVi.searchResultCount` header and a manga-card grid; empty state with `noResults` (no count phrase); error state with Vietnamese message and a retry control calling `provider.retry()`; embed `SearchPaginationControls`
    - _Requirements: 6.1, 6.4, 6.5, 6.6, 6.7, 6.8, 7.1, 7.2, 7.3, 7.4, 7.5, 8.6_

  - [ ]* 8.2 Write widget and debounce tests for `SearchScreen`
    - Renders title input, creator/tag selectors, submit and clear controls with `AppStringsVi` labels; loading/empty/error/results states render correctly; pagination controls appear and disable correctly when `totalPages > 1`; retry invokes `provider.retry()`; with `fakeAsync`, typing then advancing by the interval fires exactly one search and a zero interval fires immediately
    - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5, 6.6, 6.7, 6.8, 7.1, 7.3, 7.4, 7.5, 8.1_

- [ ] 9. Wire the search feature into the app
  - [ ] 9.1 Register `SearchProvider`, wire the `/search` route, and export the screen
    - Register `SearchProvider` in `lib/main.dart` via `ChangeNotifierProxyProvider<MangaApiService, SearchProvider>` following the existing proxy pattern
    - Replace the `/search` placeholder target in `lib/core/routes/app_router.dart` with `SearchScreen`
    - Export `search/search_screen.dart` from `lib/presentation/screens/screens.dart`
    - _Requirements: 9.1, 9.2_

  - [ ]* 9.2 Write routing tests for `/search`
    - `AppRouter.generateRoute` for `/search` builds `SearchScreen` rather than `PlaceholderScreen`
    - _Requirements: 9.1, 9.2_

- [ ] 10. Final checkpoint - Ensure all tests pass
  - Run `flutter analyze` and `flutter test` (single run) in `norumanga-client/`. Ensure all tests pass, ask the user if questions arise.

## Notes

- Tasks marked with `*` are optional and can be skipped for a faster MVP; they cover unit, widget, and property-based tests.
- Each task references specific requirements clauses for traceability.
- Property tests use `glados` (≥ 100 examples each), are tagged with the `// Feature: manga-search, Property {number}: ...` comment, and map one-to-one to the design's correctness properties.
- Backend tasks (5.1, 5.2) are implemented in the separate `prm-backend` repository; task 6 validates that contract from the client side.
- Checkpoints ensure incremental validation between layers.

## Task Dependency Graph

```json
{
  "waves": [
    { "id": 0, "tasks": ["1.1", "2.1", "5.1", "6.1"] },
    { "id": 1, "tasks": ["1.2", "2.2", "2.3", "3.1", "5.2", "6.2", "6.3", "6.4", "6.5", "6.6"] },
    { "id": 2, "tasks": ["3.2", "3.3", "3.4", "3.5", "3.6", "7.1", "7.2", "7.3"] },
    { "id": 3, "tasks": ["8.1"] },
    { "id": 4, "tasks": ["8.2", "9.1"] },
    { "id": 5, "tasks": ["9.2"] }
  ]
}
```
