package com.seasun.finance.web.handler;

import java.io.IOException;
import java.util.ArrayList;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.WebSocketMessage;
import org.springframework.web.socket.WebSocketSession;

import com.alibaba.fastjson.JSONObject;
import com.seasun.finance.web.service.WebSocketService;

@Service
public class LoginWebSocketHandler implements WebSocketHandler {

	@Autowired
	private WebSocketService websocketService;

	private static final Logger logger;

	private static final ArrayList<WebSocketSession> sessions;

	static {
		sessions = new ArrayList<>();
		logger = LoggerFactory.getLogger(LoginWebSocketHandler.class);
	}

	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		logger.debug("connect to the websocket success......");
		JSONObject result = new JSONObject();
		result.put("code", "101");
		result.put("sessionId", session.getAttributes().get("sessionId"));
		String loginurl = websocketService.getQrcode(session.getAttributes().get("sessionId").toString());
		result.put("loginQrUrl", loginurl);
		session.sendMessage(new TextMessage(result.toJSONString()));
		sessions.add(session);
	}

	@Override
	public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
	}

	@Override
	public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
		if (session.isOpen()) {
			session.close();
		}
		logger.debug("websocket connection closed......");
		sessions.remove(session);
	}

	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
		logger.debug("websocket connection closed......");
		sessions.remove(session);
	}

	@Override
	public boolean supportsPartialMessages() {
		return false;
	}

	/**
	 * 给所有在线用户发送消息
	 *
	 * @param message
	 */
	public void sendMessageToUsers(TextMessage message) {
		for (WebSocketSession session : sessions) {
			try {
				if (session.isOpen()) {
					session.sendMessage(message);
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 给某个用户发送消息
	 *
	 * @param userName
	 * @param message
	 */
	public void sendMessageToUser(String sessionId, TextMessage message) {
		for (WebSocketSession session : sessions) {
			if (session.getAttributes().get("sessionId").equals(sessionId)) {
				try {
					if (session.isOpen()) {
						session.sendMessage(message);
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
				break;
			}
		}
	}
}