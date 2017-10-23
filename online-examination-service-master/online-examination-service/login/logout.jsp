
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%
	if (session.getAttribute("nickname") != null
		|| session.getAttribute("id") != null
			|| session.getAttribute("level") != null) {
		session.invalidate();
	}

	response.sendRedirect("../");
%>
