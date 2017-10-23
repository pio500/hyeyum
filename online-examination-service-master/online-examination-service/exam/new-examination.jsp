
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<!DOCTYPE>
<html>
<head>
	<script type="text/javascript" src=".././resources/js/jquery-2.1.1.js"></script>
	<script type="text/javascript" src=".././resources/js/lyk.js"></script>
	<link rel="stylesheet" type="text/css" href=".././resources/css/blocksitstyle.css">
	<script type="text/javascript" src=".././resources/js/blocksit.min.js"></script>
	
    <link href=".././resources/css/lyk.css" rel="stylesheet">

	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="utf-8">
	<title>시험지 생성</title>
</head>
<body>
	<div id="wrapper">
		<%@include file=".././commonNav.jsp"  %>
		<%@include file=".././commonSign.jsp"%>
		<div id="container">
			<div class="exam_information row">
				<div class="ibox" style="text-align: center;">
					<div class="ibox-title">
						<b><font style="margin: 0 auto; float: none;">시험지 생성</font></b>
					</div>
					<div class="ibox-content">
						<b class="b_btn_left">시험 명 : </b>
							<input type="text" id="exam_name" required="required" class="input_btn_left"><br><br><br>
						<b class="b_btn_left">시험 설명 : </b>
							<input type="text" id="exam_explanation" required="required" class="input_btn_left"><br><br><br>
						<b class="b_btn_left">시험 비밀번호 : </b>
							<input type="text" id="exam_password" required="required" class="input_btn_left"><br><br>
						<p id="datepairExample">
   							 <b class="b_btn_left">시작 날짜 : </b>
   							 	<input type="date" class="input_btn_left datestart" required="required"/>
    							<input type="time" class="input_btn_left timestart" required="required" /><br><br><br>
    						 <b class="b_btn_left">종료 날짜 : </b>
    						 <input type="date" class="dateend input_btn_left" required="required" />
    						 <input type="time" class="timeend input_btn_left" required="required" /><br><br>
						</p>
					</div>
					
				</div>
			</div>
			<div class="row" id="select_question">
				<div class="ibox" style="text-align: center;">
					<div class="ibox-title">
						<b><font style="margin: 0 auto; float: none;">시험문항 생성</font></b>
					</div>
					<div class="ibox-content">
						<button id="multiple_choice">객관식 문제 생성</button>
						<button id="short_answer_question">주관식 문제 생성</button>
						<button id="load_question">기존 시험 문제 가져오기</button>
					</div>
					
				</div>
			</div>
			<div class="row">
				<div class="ibox" style="text-align: center;">
					<button id="exam_submit_btn" style="padding: 10px 30px; width: 100%; background-color: white; border: 1px solid white; border-radius: 3px" >시험 등록</button>
					<script type="text/javascript"> 
						$("#exam_submit_btn").click(function() {
							if($(".qn").size()==0) {
								flag = false;
								return false;
							}
							var _exam_name = $("#exam_name").val();
							if(_exam_name=="") {
								alert("시험 이름을 입력하세요.");
								return false;
							}
							var _exam_explanation = $("#exam_explanation").val();
							if(_exam_explanation=="") {
								alert("시험 설명을 입력하세요.");
								return false;
							}
							var _exam_password = $("#exam_password").val();
							var _datestart = $(".datestart").val();
							if(_datestart=="") {
								alert("시험 시작 날짜를 입력하세요.");
								return false;
							}
							var _dateend = $(".dateend").val();
							if(_dateend=="") {
								alert("시험 시작 시간을 입력하세요.");
								return false;
							}
							var _timestart = $(".timestart").val();
							if(_timestart=="") {
								alert("시험 종료 날짜를 입력하세요.");
								return false;
							}
							var _timeend = $(".timeend").val();
							if(_timeend=="") {
								alert("시험 종료 시간을 입력하세요.");
								return false;
							}
							var flag = true;
							var _question_list = "";
							var _score_list = "";
							var _question_num = 0;
							$(".qn").each(function() {
								if($(this).children().data("eid")!=null) {
									_question_list += $(this).children().data("eid") + "###";
									if($(this).children().children().first().children().last().val()=="") {
										alert("시험 점수를 입력해 주세요.");
										flag = false;
										return false;
									}
									_question_num++;
									_score_list += $(this).children().children().first().children().last().val() + "@@@";
								}
							});
							if(_question_num==0) {
								alert("시험 문제를 추가해 주세요.");
								return false;
							}
							if(flag == false) return false;
							
							$.ajax({
								type : "post",
								url : "./nExamSubmitProcess.jsp",
								dataType : "text",
								data : {
									exam_name 			:_exam_name,
									exam_explanation 	: _exam_explanation,
									datestart 			:_datestart,
									dateend				:_dateend,
									timestart			:_timestart,
									timeend				:_timeend,
									question_list		:_question_list,
									score_list			:_score_list,
									exam_password		:_exam_password
								},
								success : function(data) {
									//여기서 jsp 넘겨주면됨.
									location.href = "./submit.jsp";
								},
								error : function(e, xhr) {
									alert(e.status + ">" + xhr)
								},
								cache : false,
								async : false,
								contentType : "application/x-www-form-urlencoded;charset=utf-8"
							});
						});
					</script>
				</div>
			</div>
		</div>
	</div>
<!--
	
-->
	<script type="text/javascript"> 
						var question_number = "";
						var number = 1;
						function atsdgsd(test) {
							var temp = ".p" + test;
							var t = $(temp).parent().children().last().data("tid");
							$(temp).last().parent().first().append("<br><b class=\"b_btn_left\">" + (t+1) + " 번 : </b><input type=\"text\" class=\"s1 p" + test + "\" data-tid=\"" + (t+1) + "\"  style=\"padding: 5px 20px; margin-top: 5px;\" >" );
						}
						$("#multiple_choice").click(function() {
							var selection_num = 1;
							
							var tmp =   "<div class=\"qn row_1\" data-id=\"" + number + "\">" +
											"<div class=\"ibox\">" +
									  			"<div class=\"ibox-title\">" +
									  	  			"<b><font>" + number++ + "번 문항 - 객관식 추가</font></b><br> " +
									  	  			"<br><b class=\"b_btn_left\">문제 제목 : </b><input class=\"title\" type=\"text\"><br><br><br>" +
									  	  			"<b class=\"b_btn_left\">문제 : </b><input class=\"text\" type=\"text\"><br><br><br>" +
								  	  				"<b class=\"b_btn_left\">문제 답 : </b><input class=\"answer\" type=\"text\"><br><br><br>" +
								  	  				"<b class=\"b_btn_left\">문제 답 설명 : </b><input class=\"answer_explanation\" type=\"text\"><br><br><br>" +
									  	  			"<b class=\"b_btn_left\">문제 참조 : </b><input class=\"etc\" type=\"etc\"><br><br><br>" +
								  	  				"<div class=\"set\">" + 
									  				"<b  class=\"b_btn_left\">1 번 : </b><input type=\"text\" class=\"s1 p" + (number-1) + "\" data-tid=\"1\" style=\"padding: 5px 20px;\">" +
									  				"</div><br><button class=\"set_btn\" onclick=\"atsdgsd(" + (number-1) + ");\">추가</button>" + 
									  				"　<button id=\"question_create_btn_1\" data-id=\"" + (number-1) + "\">문제 등록</button>" + 
									  			"</div>" +
									  		"</div>" + 
									  	"</div>";
							$("#select_question").append(tmp);
							$(".row_1").each( function(index) {
								$(this).children().children().children().last().off( "click" );
								$(this).children().children().children().last().on( "click", function()  { 
									var t1 = "";
									var p = $(this).parent().children();
									var _title, _text, _answer, _answer_explanation, _etc;
									p.each(function() {
										if($(this).hasClass("title")) _title = $(this).val();
										if($(this).hasClass("text")) _text = $(this).val();
										if($(this).hasClass("answer")) _answer = $(this).val();
										if($(this).hasClass("answer_explanation")) _answer_explanation = $(this).val();
										if($(this).hasClass("etc")) _etc = $(this).val();
										
										if($(this).hasClass("set")) {
											var t3 = 1;
											$(this).children().each(function() {
												if($(this).hasClass("s1")) t1 +=  $(this).val() + "###";
											});
										}
										
									});
									$.ajax({
										type : "post",
										url : "./nQuestionSubmitProcessNum.jsp",
										dataType : "text",
										data : {
											title : _title,
											text : _text,
											answer : _answer,
											answer_explanation : _answer_explanation,
											category : "num",
											t : $(this).data("id"),
											selection : t1,
											etc : _etc
										},
										success : function(data) {
											p.parent().parent().parent().html(data.trim());
										},
										error : function(e, xhr) {
											alert(e.status + ">" + xhr)
										},
										cache : false,
										async : false,
										contentType : "application/x-www-form-urlencoded;charset=utf-8"
									});
								});
							});
						});
						$("#short_answer_question").click(function() {
							var tmp =   "<div class=\"qn row_2\" data-id=\"" + number + "\">" +
											"<div class=\"ibox\">" +
									  			"<div class=\"ibox-title\">" +
									 	 			"<b><font>" + number++ + "번 문항 - 주관식 추가</font></b><br>" +
									  	  			"<br><b class=\"b_btn_left\">문제 제목 : </b><input class=\"title\" type=\"text\"><br><br><br>" +
									  	  			"<b class=\"b_btn_left\">문제 : </b><input class=\"text\" type=\"text\"><br><br><br>" +
							  	  					"<b class=\"b_btn_left\">문제 답 : </b><input class=\"answer\" type=\"text\"><br><br><br>" +
							  	  					"<b class=\"b_btn_left\">문제 답 설명 : </b><input class=\"answer_explanation\" type=\"text\"><br><br><br>" +
								  	  				"<b class=\"b_btn_left\">문제 참조 : </b><input class=\"etc\" type=\"etc\"><br><br><br>" +
									  	  			"<button id=\"question_create_btn_2\" data-id=\"" + (number-1) + "\">문제 등록</button>" + 
									  			"</div>" +
									  		"</div>" + 
									  	"</div>";
							$("#select_question").append(tmp);
							$(".row_2").each( function(index) {
								$(this).children().children().children().last().off( "click" );
								$(this).children().children().children().last().on( "click", function()  { 
									var p = $(this).parent().children();

									var _title, _text, _answer, _answer_explanation, _etc;
									p.each(function() {
										if($(this).hasClass("title")) _title = $(this).val();
										if($(this).hasClass("text")) _text = $(this).val();
										if($(this).hasClass("answer")) _answer = $(this).val();
										if($(this).hasClass("answer_explanation")) _answer_explanation = $(this).val();
										if($(this).hasClass("etc")) _etc = $(this).val();
									});
									$.ajax({
										type : "post",
										url : "./nQuestionSubmitProcessString.jsp",
										dataType : "text",
										data : {
											title : _title,
											text : _text,
											answer : _answer,
											answer_explanation : _answer_explanation,
											category : "string",
											t : $(this).data("id"),
											etc : _etc
										},
										success : function(data) {
											p.parent().parent().parent().html(data.trim());
										},
										error : function(e, xhr) {
											alert(e.status + ">" + xhr)
										},
										cache : false,
										async : false,
										contentType : "application/x-www-form-urlencoded;charset=utf-8"
									});
								});
							});
						});
					</script>
	<script type="text/javascript">
		$("#submit").css("background-color","#293846").css("border-left","5px solid #6F141F").css("color","white");
		$("#submit").addClass("activate");
	</script>
</body>
</html>