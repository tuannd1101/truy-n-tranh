# Requirements Document

## Introduction

This feature adds a Manga Search capability that lets users find manga by title keyword, by creator (author/artist), and by tag, with these criteria combinable in a single query. The work spans two repositories:

- **Frontend** (`norumanga-client/`, this workspace): a Flutter app using Provider state management and a Dio-based HTTP client. The search experience includes a dedicated search screen with input controls, a results view showing a count of matching manga, and pagination controls.
- **Backend** (`prm-backend`, a separate Spring Boot repository not in this workspace, documented in `my-doc/skill/be/api_document.md`): the API must return paginated manga results that accurately match the supplied criteria. The current API exposes `GET /api/mangas/search` (title/slug/description keyword only) and `GET /api/mangas/` (filter by genreId, tagId, status, licenseStatus), but has **no** way to filter manga by creator. The backend portion of this feature extends the manga query endpoint to accept a creator filter combined with keyword and tag, returning a paginated result.

The backend response continues to use the standard `BaseApiResponse` envelope wrapping a Spring `Page` object: `{ data: { content: [...], totalElements, totalPages, number, size, first, last, numberOfElements, empty }, message, error }`.

All user-facing text is in Vietnamese, reusing and extending `lib/core/constants/app_strings_vi.dart`, and the UI follows the existing "Manga Brutalism" dark theme.

## Glossary

- **Search_Feature**: The end-to-end manga search capability spanning backend API and Flutter client.
- **Manga_Query_Endpoint**: The backend HTTP endpoint that returns a paginated list of manga matching supplied filter criteria. In the current API this corresponds to `GET /api/mangas/` extended with a creator filter, returning a Spring `Page<MangaResponseDTO>`.
- **Search_Criteria**: The set of optional filters a user supplies: a title keyword, a creator selection, and a tag selection.
- **Title_Keyword**: A free-text string matched against a manga title (and, on the backend, slug and description as currently implemented by `/api/mangas/search`).
- **Creator_Filter**: A single creator identifier (author or artist) used to restrict results to manga associated with that creator.
- **Tag_Filter**: One or more tag identifiers used to restrict results to manga associated with those tags.
- **Page_Index**: A zero-based page number used by the backend (Spring convention).
- **Page_Number**: A one-based page number displayed to and selected by the user in the Flutter client.
- **Page_Size**: The maximum number of manga returned in a single page of results.
- **Result_Count**: The total number of manga matching the Search_Criteria across all pages, corresponding to `totalElements` in the backend response.
- **Search_Response**: The backend response payload containing the paginated manga list and pagination metadata inside the `BaseApiResponse` envelope.
- **Search_Screen**: The Flutter screen at `lib/presentation/screens/search/search_screen.dart` that hosts the search controls and results.
- **Search_Provider**: The Flutter `ChangeNotifier` that holds Search_Criteria, results, Result_Count, pagination state, and request status for the Search_Screen.
- **Manga_Api_Service**: The Flutter service at `lib/data/network/manga_api_service.dart` responsible for issuing search requests to the backend.
- **Pagination_Controls**: The Flutter UI elements (previous button, next button, page-number indicators) that let the user navigate between result pages.
- **Creator_Selector**: The Flutter UI control that lets the user search for and select a creator as the Creator_Filter.
- **Tag_Selector**: The Flutter UI control that lets the user select one or more tags as the Tag_Filter.
- **Empty_State**: The Search_Screen condition shown when a completed search returns zero matching manga.
- **Loading_State**: The Search_Screen condition shown while a search request is in progress.
- **Error_State**: The Search_Screen condition shown when a search request fails.
- **Debounce_Interval**: The fixed waiting period after the user stops typing the Title_Keyword before an automatic search request is issued.

## Requirements

### Requirement 1: Backend manga query by combined criteria

**User Story:** As a reader, I want the backend to return manga that match my title, creator, and tag filters together, so that the results accurately reflect what I searched for.

#### Acceptance Criteria

1. WHERE a Title_Keyword is supplied, THE Manga_Query_Endpoint SHALL return only manga whose title, slug, or description matches the Title_Keyword.
2. WHERE a Creator_Filter is supplied, THE Manga_Query_Endpoint SHALL return only manga associated with the identified creator as an author or artist.
3. WHERE a Tag_Filter is supplied, THE Manga_Query_Endpoint SHALL return only manga associated with every tag identifier in the Tag_Filter.
4. WHERE more than one of Title_Keyword, Creator_Filter, and Tag_Filter are supplied, THE Manga_Query_Endpoint SHALL return only manga that satisfy all supplied criteria simultaneously.
5. WHERE no Search_Criteria are supplied, THE Manga_Query_Endpoint SHALL return the unfiltered manga list.

### Requirement 2: Backend pagination of search results

**User Story:** As a reader, I want manga results delivered one page at a time with a total count, so that the client can display them in manageable pages and show how many matches exist.

#### Acceptance Criteria

1. WHEN the Manga_Query_Endpoint receives a request, THE Manga_Query_Endpoint SHALL return a Search_Response containing a content list, totalElements, totalPages, number, size, first, last, numberOfElements, and empty fields.
2. WHERE a Page_Index is supplied, THE Manga_Query_Endpoint SHALL return the page of results at that Page_Index.
3. WHERE a Page_Size is supplied, THE Manga_Query_Endpoint SHALL return at most Page_Size manga in the content list.
4. WHERE no Page_Index is supplied, THE Manga_Query_Endpoint SHALL default the Page_Index to 0.
5. WHERE no Page_Size is supplied, THE Manga_Query_Endpoint SHALL default the Page_Size to 20.
6. THE Manga_Query_Endpoint SHALL set totalElements in the Search_Response to the count of all manga matching the Search_Criteria across all pages.
7. WHEN the requested Page_Index is greater than or equal to totalPages, THE Manga_Query_Endpoint SHALL return an empty content list with the empty field set to true.

### Requirement 3: Backend response envelope and error handling

**User Story:** As a client developer, I want search responses in the standard envelope with clear errors, so that I can parse results and surface failures consistently.

#### Acceptance Criteria

1. WHEN the Manga_Query_Endpoint returns successfully, THE Manga_Query_Endpoint SHALL wrap the paginated result in a BaseApiResponse with a non-null data field and a null error field.
2. IF a supplied Page_Index is negative, THEN THE Manga_Query_Endpoint SHALL return a BaseApiResponse with a null data field and an error field describing the invalid pagination parameter.
3. IF a supplied Page_Size is less than 1, THEN THE Manga_Query_Endpoint SHALL return a BaseApiResponse with a null data field and an error field describing the invalid pagination parameter.
4. IF a supplied Creator_Filter identifier does not correspond to an existing creator, THEN THE Manga_Query_Endpoint SHALL return a Search_Response with an empty content list and totalElements equal to 0.

### Requirement 4: Client search request construction

**User Story:** As a reader, I want the app to send my title, creator, and tag selections to the backend, so that the results match the criteria I chose.

#### Acceptance Criteria

1. THE Manga_Api_Service SHALL expose a search operation that accepts an optional Title_Keyword, an optional Creator_Filter, an optional Tag_Filter, a Page_Index, and a Page_Size.
2. WHEN the search operation is invoked with a Title_Keyword, THE Manga_Api_Service SHALL include the Title_Keyword as a query parameter in the request to the Manga_Query_Endpoint.
3. WHEN the search operation is invoked with a Creator_Filter, THE Manga_Api_Service SHALL include the creator identifier as a query parameter in the request to the Manga_Query_Endpoint.
4. WHEN the search operation is invoked with a Tag_Filter, THE Manga_Api_Service SHALL include the tag identifier as a query parameter in the request to the Manga_Query_Endpoint.
5. WHEN the search operation completes successfully, THE Manga_Api_Service SHALL return a result containing the manga list, totalPages, totalElements, and current Page_Index parsed from the Search_Response.
6. IF the search request fails, THEN THE Manga_Api_Service SHALL raise an ApiException carrying a descriptive message.

### Requirement 5: Client search state management

**User Story:** As a reader, I want the app to track my current search and its results, so that the interface stays consistent as I change criteria and pages.

#### Acceptance Criteria

1. THE Search_Provider SHALL hold the current Title_Keyword, Creator_Filter, Tag_Filter, manga results, Result_Count, current Page_Number, and total page count.
2. WHEN the user submits a search, THE Search_Provider SHALL request results for Page_Index 0 using the current Search_Criteria.
3. WHILE a search request is in progress, THE Search_Provider SHALL expose a loading status to the Search_Screen.
4. WHEN a search request completes successfully, THE Search_Provider SHALL update the manga results, Result_Count, current Page_Number, and total page count from the returned data.
5. IF a search request fails, THEN THE Search_Provider SHALL expose an error message to the Search_Screen.
6. WHEN the user clears the Search_Criteria, THE Search_Provider SHALL reset the Title_Keyword, Creator_Filter, Tag_Filter, manga results, and Result_Count to their empty values.
7. WHEN the user selects a Page_Number, THE Search_Provider SHALL request the corresponding page using the unchanged Search_Criteria.

### Requirement 6: Client search input controls

**User Story:** As a reader, I want clear inputs and buttons to enter my search, so that I can find manga by title, creator, or tag.

#### Acceptance Criteria

1. THE Search_Screen SHALL display a text input for the Title_Keyword.
2. THE Search_Screen SHALL display a Creator_Selector for choosing a Creator_Filter.
3. THE Search_Screen SHALL display a Tag_Selector for choosing a Tag_Filter.
4. THE Search_Screen SHALL display a submit control that triggers a search using the current Search_Criteria.
5. THE Search_Screen SHALL display a clear control that resets all Search_Criteria.
6. WHEN the user stops editing the Title_Keyword for the Debounce_Interval, THE Search_Screen SHALL trigger a search using the current Search_Criteria.
7. WHERE the Debounce_Interval is configured to zero, THE Search_Screen SHALL trigger a search immediately when the user edits the Title_Keyword.
8. THE Search_Screen SHALL render all input labels, button labels, and placeholder text in Vietnamese using constants from `lib/core/constants/app_strings_vi.dart`.

### Requirement 7: Client results display with count

**User Story:** As a reader, I want to see how many manga matched and view them as cards, so that I can gauge and browse the results.

#### Acceptance Criteria

1. WHEN a search completes with one or more matching manga, THE Search_Screen SHALL display the matching manga as a grid or list of manga cards.
2. WHEN a search completes with one or more matching manga, THE Search_Screen SHALL display the Result_Count using the Vietnamese phrase "Tìm thấy {count} truyện".
3. WHILE a search request is in progress, THE Search_Screen SHALL display a Loading_State.
4. WHEN a search completes with zero matching manga, THE Search_Screen SHALL display an Empty_State with Vietnamese text indicating no results were found, without displaying the Result_Count phrase.
5. IF a search request fails, THEN THE Search_Screen SHALL display an Error_State with a Vietnamese error message and a retry control.

### Requirement 8: Client pagination controls

**User Story:** As a reader, I want page navigation controls, so that I can move through all pages of matching manga.

#### Acceptance Criteria

1. WHEN a search returns more than one page of results, THE Search_Screen SHALL display Pagination_Controls including a previous control, a next control, and the current Page_Number out of the total page count.
2. WHEN the user activates the next control, THE Search_Screen SHALL request the next Page_Number using the unchanged Search_Criteria.
3. WHEN the user activates the previous control, THE Search_Screen SHALL request the previous Page_Number using the unchanged Search_Criteria.
4. WHILE the current Page_Number is 1, THE Search_Screen SHALL disable the previous control.
5. WHILE the current Page_Number equals the total page count, THE Search_Screen SHALL disable the next control.
6. WHEN the user navigates to a different page, THE Search_Screen SHALL display the manga belonging to that page.

### Requirement 9: Search screen routing and navigation

**User Story:** As a reader, I want to reach the search screen from the app navigation, so that I can start searching from anywhere appropriate.

#### Acceptance Criteria

1. THE Search_Feature SHALL register the Search_Screen on the existing `/search` route defined in `lib/core/routes/app_router.dart`.
2. WHEN the user navigates to the `/search` route, THE Search_Feature SHALL display the Search_Screen instead of the current placeholder screen.
