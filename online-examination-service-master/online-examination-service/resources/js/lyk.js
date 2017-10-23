/**
 * 
 */
function b_hit_up(_id, _board, _p) {
	var tmp = window.location.href;
	var tmp2 = window.location.pathname;
	var flag = tmp.indexOf("lyk");
	tmp = tmp.substring(0, flag);
	$.ajax({
		type : "post",
		url : tmp + "lyk/bbs/hit_up.jsp",
		dataType : "text",
		data : {
			id : _id
		},
		success : function(data) {
			location.href = tmp + "lyk/bbs/read.jsp?b=freeboard" + "&p=" + _p
					+ "&n=" + _id;
		},
		error : function(e, xhr) {
			alert(e.status + ">" + xhr)
		},
		cache : false,
		async : false,
		contentType : "application/x-www-form-urlencoded;charset=utf-8"
	});
	return false;
}
function n_hit_up(_id, _board, _p) {
	var tmp = window.location.href;
	var tmp2 = window.location.pathname;
	var flag = tmp.indexOf("lyk");
	tmp = tmp.substring(0, flag);
	$.ajax({
		type : "post",
		url : tmp + "lyk/bbs/hit_up.jsp",
		dataType : "text",
		data : {
			id : _id
		},
		success : function(data) {
			location.href = tmp + "lyk/bbs/read.jsp?b=notice" + "&p=" + _p
					+ "&n=" + _id;
		},
		error : function(e, xhr) {
			alert(e.status + ">" + xhr)
		},
		cache : false,
		async : false,
		contentType : "application/x-www-form-urlencoded;charset=utf-8"
	});
	return false;
}

$(function() {

	$("#lyk_menu ul li").mouseover(
			function() {
				var width = $("#nav").width();
				var tmp = $(this).parent().children();
				tmp.each(function(index) {
					if (!$(this).hasClass("activate"))
						$(this).css("background-color", "#284050").css("color",
								"#8C97A8");
				});
				// $(this).css("background-color","#293846").css("width",width-5).css("border-left","5px
				// solid #ddd").css("color","white");
				if (!$(this).hasClass("activate"))
					$(this).css("background-color", "#293846").css("color",
							"white");
			});

	$("#lyk_menu ul").mouseout(
			function() {
				var width = $("#nav").width();
				var tmp = $(this).children();
				tmp.each(function(index) {
					if (!$(this).hasClass("activate"))
						$(this).css("background-color", "#284050").css("color",
								"#8C97A8");
				});
			});
	$("#lyk_menu ul li").click(function() {
		var tmp = window.location.href;
		var tmp2 = window.location.pathname;
		var flag = tmp.indexOf("lyk");
		tmp = tmp.substring(0, flag);
		var index = $(this).data("index");
		if (index == 1)
			location.href = tmp + "lyk";
		else if (index == 2)
			location.href = tmp + "lyk/bbs/notice.jsp";
		else if (index == 3)
			location.href = tmp + "lyk/bbs/board.jsp";
		else if (index == 4)
			location.href = tmp + "lyk/exam/submit.jsp";
		else if (index == 5)
			location.href = tmp + "lyk/exam/examination.jsp";
		else if (index == 6)
			location.href = tmp + "lyk/user/mypage.jsp";
	});
	$("#password").keydown(function(key) {
		if (key.keyCode == 13) {
			$("#login_btn").click();
		}
	});
	$("#login_btn").click(function() {

		var tmp = window.location.href;
		var tmp2 = window.location.pathname;
		var flag = tmp.indexOf("lyk");
		tmp = tmp.substring(0, flag);

		var id = $("#username").val();
		var pw = $("#password").val();
		$.ajax({
			type : "post",
			url : tmp + "/lyk/login/login.jsp",
			dataType : "text",
			data : {
				j_username : id,
				j_password : pw
			},
			success : function(data) {
				data = data.trim();
				if (data == "Y")
					location.href = document.referrer
				else {
					alert("비밀번호가 틀렸습니다.");
					$("#password").val("");
					$("#password").focus();
				}
			},
			error : function(e, xhr) {
				alert("아이디가 존재하지 않습니다. 아이디를 새로 생성해주세요.");
			},
			cache : false,
			async : false,
			contentType : "application/x-www-form-urlencoded;charset=utf-8"
		});
		return false;
	});

	/*
	 * $("#logout_btn").click(function() { $.ajax({ type : "post", url :
	 * "./login/logout.jsp", dataType : "text", data : {
	 *  }, success : function(data) { location.href=document.referrer }, error :
	 * function(e, xhr) { alert(e.status + ">" + xhr) }, cache : false, async :
	 * false, contentType : "application/x-www-form-urlencoded;charset=utf-8"
	 * }); });
	 */
});
