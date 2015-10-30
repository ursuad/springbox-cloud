package io.springbox.recommendations.config;

import org.neo4j.graphdb.GraphDatabaseService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.data.neo4j.rest.SpringRestGraphDatabase;

@Configuration
@Profile("default")
public class LocalConfig {

    @Value("${spring.data.neo4j.host}")
    private String neo4jHost;

    @Value("${spring.data.neo4j.port}")
    private String neo4jPort;

    @Bean
    public GraphDatabaseService graphDatabaseService() {
        return new SpringRestGraphDatabase("http://"+neo4jHost+":"+neo4jPort+"/db/data/");
    }

}
