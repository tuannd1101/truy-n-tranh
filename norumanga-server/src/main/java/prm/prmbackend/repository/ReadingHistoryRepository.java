package prm.prmbackend.repository;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;
import prm.prmbackend.entity.ReadingHistory;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReadingHistoryRepository extends MongoRepository<ReadingHistory, String> {

    List<ReadingHistory> findByAccountIdOrderByLastReadAtDesc(String accountId);

    Optional<ReadingHistory> findByAccountIdAndMangaId(String accountId, String mangaId);

    void deleteByAccountId(String accountId);
}
