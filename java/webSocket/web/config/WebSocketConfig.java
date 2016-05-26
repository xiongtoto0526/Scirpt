package com.seasun.finance.config;

import com.seasun.finance.web.handler.UploadHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

import com.seasun.finance.web.handler.LoginWebSocketHandler;
import com.seasun.finance.web.interceptor.WebSocketHandshakeInterceptor;

@Configuration
@EnableWebSocket
public class WebSocketConfig extends WebMvcConfigurerAdapter implements WebSocketConfigurer {

	@Autowired
	private LoginWebSocketHandler loginWebSocketHandler;

	@Autowired
	private UploadHandler uploadHandler;

	@Override
	public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
		registry.addHandler(loginWebSocketHandler, "/login-socket").addInterceptors(new WebSocketHandshakeInterceptor())
				.setAllowedOrigins("*");

		registry.addHandler(loginWebSocketHandler, "/sockjs/login-socket")
				.addInterceptors(new WebSocketHandshakeInterceptor()).setAllowedOrigins("*").withSockJS();

		registry.addHandler(uploadHandler, "/upload-socket")
				.addInterceptors(new WebSocketHandshakeInterceptor()).setAllowedOrigins("*");
	}

}