package com.example.nexa.config;
//
////import org.springframework.amqp.core.Binding;
////import org.springframework.amqp.core.BindingBuilder;
////import org.springframework.amqp.core.Queue;
////import org.springframework.amqp.core.TopicExchange;
////import org.springframework.context.annotation.Bean;
////import org.springframework.context.annotation.Configuration;
////
////@Configuration
////public class RabbitMQConfig {
////    @Bean
////    public Queue imageAnalysisQueue() {
////        return new Queue("interior-image-analysis-queue", true);
////    }
////
////    @Bean
////    public TopicExchange imageAnalysisExchange() {
////        return new TopicExchange("interior-image-analysis-exchange");
////    }
////
////    @Bean
////    public Binding binding(Queue queue, TopicExchange exchange) {
////        return BindingBuilder.bind(queue).to(exchange).with("image.upload");
////    }
////}
//
////import org.springframework.amqp.core.Queue;
////import org.springframework.context.annotation.Bean;
////import org.springframework.context.annotation.Configuration;
////
////@Configuration
////public class RabbitMQConfig {
////    public static final String QUEUE_NAME = "image-processing-queue";
//////    public static final String CLUSTERING_QUEUE = "clustering-queue";
////
////    @Bean
////    public Queue queue() {
////        return new Queue(QUEUE_NAME, true);
////    }
//////    @Bean
//////    public Queue clusteringQueue() {
//////        return new Queue(CLUSTERING_QUEUE, true);
//////    }
////
////    public static final String CLUSTERING_QUEUE = "user-clustering-queue";
////
////    @Bean
////    public Queue clusteringQueue() {
////        return new Queue(CLUSTERING_QUEUE, true);
////    }
////
////    public static final String COMPLEXITY_QUEUE = "complexity-analysis-queue";
////    @Bean
////    public Queue complexityQueue() {
////        return new Queue(COMPLEXITY_QUEUE, true);
////    }
////
////
////}
//
//
//// RabbitMQConfig.java
//import com.rabbitmq.client.ConnectionFactory;
//import org.springframework.amqp.core.*;
//import org.springframework.amqp.rabbit.core.RabbitTemplate;
//import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//
//@Configuration
//public class RabbitMQConfig {
//    // Existing queues
//    public static final String QUEUE_NAME = "image-processing-queue";
//    public static final String CLUSTERING_QUEUE = "user-clustering-queue";
//    public static final String COMPLEXITY_QUEUE = "complexity-analysis-queue";
//
//    // New queues for color palette
//    public static final String COLOR_PALETTE_QUEUE = "color-palette-queue";
//    public static final String COLOR_PALETTE_RESPONSE_QUEUE = "color-palette-response-queue";
//    public static final String COLOR_PALETTE_EXCHANGE = "color-palette-exchange";
//    public static final String COLOR_ROUTING_KEY = "color.generate";
//
//    // Existing queue beans
//    @Bean
//    public Queue queue() {
//        return new Queue(QUEUE_NAME, true);
//    }
//
//    @Bean
//    public Queue clusteringQueue() {
//        return new Queue(CLUSTERING_QUEUE, true);
//    }
//
//    @Bean
//    public Queue complexityQueue() {
//        return new Queue(COMPLEXITY_QUEUE, true);
//    }
//
//    // New beans for color palette functionality
//    @Bean
//    public Queue colorPaletteQueue() {
//        return new Queue(COLOR_PALETTE_QUEUE, true);
//    }
//
//    @Bean
//    public Queue colorPaletteResponseQueue() {
//        return new Queue(COLOR_PALETTE_RESPONSE_QUEUE, true);
//    }
//
//    @Bean
//    public DirectExchange colorPaletteExchange() {
//        return new DirectExchange(COLOR_PALETTE_EXCHANGE);
//    }
//
//    @Bean
//    public Binding colorPaletteBinding() {
//        return BindingBuilder.bind(colorPaletteQueue())
//                .to(colorPaletteExchange())
//                .with(COLOR_ROUTING_KEY);
//    }
//
//    @Bean
//    public Jackson2JsonMessageConverter jsonMessageConverter() {
//        return new Jackson2JsonMessageConverter();
//    }
//
//    @Bean
//    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
//        RabbitTemplate template = new RabbitTemplate((org.springframework.amqp.rabbit.connection.ConnectionFactory) connectionFactory);
//        template.setMessageConverter(jsonMessageConverter());
//        return template;
//    }
//}


import org.springframework.amqp.core.*;
import org.springframework.amqp.rabbit.connection.ConnectionFactory;
import org.springframework.amqp.rabbit.core.RabbitTemplate;
import org.springframework.amqp.support.converter.Jackson2JsonMessageConverter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class RabbitMQConfig {
    public static final String QUEUE_NAME = "image-processing-queue";
    public static final String CLUSTERING_QUEUE = "user-clustering-queue";
    public static final String COMPLEXITY_QUEUE = "complexity-analysis-queue";

    public static final String COLOR_PALETTE_QUEUE = "color-palette-queue";
    public static final String COLOR_PALETTE_RESPONSE_QUEUE = "color-palette-response-queue";
    public static final String COLOR_PALETTE_EXCHANGE = "color-palette-exchange";
    public static final String COLOR_ROUTING_KEY = "color.generate";

    @Bean
    public Queue queue() {
        return new Queue(QUEUE_NAME, true);
    }

    @Bean
    public Queue clusteringQueue() {
        return new Queue(CLUSTERING_QUEUE, true);
    }

    @Bean
    public Queue complexityQueue() {
        return new Queue(COMPLEXITY_QUEUE, true);
    }

    @Bean
    public Queue colorPaletteQueue() {
        return new Queue(COLOR_PALETTE_QUEUE, true);
    }

    @Bean
    public Queue colorPaletteResponseQueue() {
        return new Queue(COLOR_PALETTE_RESPONSE_QUEUE, true);
    }

    @Bean
    public DirectExchange colorPaletteExchange() {
        return new DirectExchange(COLOR_PALETTE_EXCHANGE);
    }

    @Bean
    public Binding colorPaletteBinding() {
        return BindingBuilder.bind(colorPaletteQueue())
                .to(colorPaletteExchange())
                .with(COLOR_ROUTING_KEY);
    }

    @Bean
    public Jackson2JsonMessageConverter jsonMessageConverter() {
        return new Jackson2JsonMessageConverter();
    }

//    @Bean
//    public RabbitTemplate rabbitTemplate(ConnectionFactory connectionFactory) {
//        RabbitTemplate template = new RabbitTemplate(connectionFactory);
//        template.setMessageConverter(jsonMessageConverter());
//        return template;
//    }

    @Bean
    public RabbitTemplate rabbitTemplate(org.springframework.amqp.rabbit.connection.ConnectionFactory connectionFactory) {
        RabbitTemplate template = new RabbitTemplate(connectionFactory);
        template.setMessageConverter(jsonMessageConverter());
        return template;
    }

}
