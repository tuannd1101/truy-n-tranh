package prm.prmbackend.component;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import prm.prmbackend.entity.Role;
import prm.prmbackend.repository.RoleRepository;

import java.util.List;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataInitializer implements CommandLineRunner {

    private final RoleRepository roleRepository;

    @Override
    public void run(String... args) throws Exception {
        log.info("Initializing Data...");

        // Define initial roles
        List<Role> initialRoles = List.of(
                Role.builder().name("Free").description("Free User").build(),
                Role.builder().name("Premium").description("Premium User").build(),
                Role.builder().name("Manager").description("System Manager").build(),
                Role.builder().name("Admin").description("System Administrator").build()
        );

        // Save roles if they don't exist
        for (Role role : initialRoles) {
            if (roleRepository.findByName(role.getName()).isEmpty()) {
                roleRepository.save(role);
                log.info("Created role: {}", role.getName());
            }
        }
        
        log.info("Data Initialization Completed.");
    }
}
