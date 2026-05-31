package prm.prmbackend.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.Favorite;

import java.util.List;
import java.util.Optional;

@Repository
public interface FavoriteRepository extends MongoRepository<Favorite, String> {

    List<Favorite> findByAccountIdOrderByCreatedAtDesc(String accountId);

    Optional<Favorite> findByAccountIdAndMangaId(String accountId, String mangaId);

    boolean existsByAccountIdAndMangaId(String accountId, String mangaId);

    void deleteByAccountIdAndMangaId(String accountId, String mangaId);
}
