<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page session="false"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!doctype html>
<html lang="ko">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"></head>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/hr/main.css">
		
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
 		<script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js" integrity="sha512-uto9mlQzrs59VwILcLiRYeLKPPbS/bT71da/OEBYEwcdNUk8jYIy+D176RYoop1Da+f9mvkYrmj5MCLZWEtQuA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css" integrity="sha512-aOG0c6nPNzGk+5zjwyJaoRUgCdOrfSDhmMID2u4+OIslr0GjpLKo7Xm0Ao3xmpM4T8AmIouRkqwj1nrdVsLKEQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
	
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
		
		<script defer>
/* ............기본 정보 리스트를 조회한다(start).............. */
$(function(){
	fn_list_show();
});
/* ............기본 정보 리스트를 조회한다(end).............. */
/* ............검색 엔터키를 누른다.(start)............. */
$(function(){
	/* 검색 엔터키 실행 */
	$("#keyword").keydown(function(key){
		if(key.keyCode == 13) {
			fn_search();
		}
	});
})
/* ............검색 엔터키를 누른다.(end)............. */
/* ..............검색 버튼을 클릭한다.(start).............. */
function fn_search() {
	console.log("fn_search 검색 함수 실행");
	let searchType = $("#searchType").val();
	let keyword = $("#keyword").val();
	$("#keyword").data("searchType", searchType);
	$("#keyword").data("keyword", keyword);
	fn_list_show();
}
/* ..............검색 버튼을 클릭한다.(end).............. */
/* ................기본정보 리스트를 조회한다.(start).............. */
function fn_list_show(choicePage) {
	console.log("fn_list_show 기본정보 조회 ajax 실행");
	
	//시작 페이징 설정
	if (choicePage == null || choicePage == "undefined" || choicePage == "") {
		choicePage = "1";
	}
	
	let formData = {
			"page" : choicePage,
			"searchType" : $("#keyword").data("searchType"),
			"keyword" : $("#keyword").data("keyword")
	}
	
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
		url : "${pageContext.request.contextPath}/emp/list.do",
		type : "POST",
		dataType : "json",
		data : formData,	
		success : function(result) {
			console.log("fn_list_show() 인사 기본정보 ajax 성공");
			// 게시판 리스트를 조회한다.
			console.log(result.list);
			let htmls = "";
			result.list.forEach(function(list){
				htmls += "<tr>";
				htmls += "<td>"+ list.emp_no + "</td>";
				htmls += "<td>"+ list.emp_name + "</td>";
				htmls += "<td>"+ list.emp_rank + "</td>";
				htmls += "<td>"+ list.emp_position + "</td>";
				htmls += "<td>"+ list.emp_join_start + "</td>";
				htmls += "<td>"+ list.emp_phone + "</td>";
				htmls += "<td>"+ list.emp_contract + "</td>";
				htmls += "<td>"+ list.emp_work + "</td>";
				htmls += "</tr>";
			});
			$("#list_ajax").html(htmls);
			
			// 게시판 페이징 처리를 한다.
			htmls = "";
			let page = result.pageMaker;
			// prev 설정
			if( page.startPage == 1 ) {
				$("#page_prev").addClass("disabled");
				$("#page_prev").children().first().removeAttr("onclick");
			} else {
				$("#page_prev").removeClass("disabled");
				$("#page_prev").children(".page-link").attr("onclick", "fn_list_show("+(page.startPage -1 )+")");
			}
			// 페이징 반복문
			for(let i=page.startPage; i<=page.endPage; i++) {
				if( choicePage == i ) {
					htmls += "<li class='page-item active'><a class='page-link' href='#none' onclick='fn_list_show("+i+");'>"+i+"</a></li>";
				}
				else {
					htmls += "<li><a class='page-link' href='#none' onclick='fn_list_show("+i+");'>"+i+"</a></li>";
				}
			}
			$("#page_ajax").html(htmls);
			// next 설정
			if( page.endPage == page.finalPage ) {
				$("#page_next").addClass("disabled");
				$("#page_next").children().first().removeAttr("onclick");
			} else {
				$("#page_next").removeClass("disabled");
				$("#page_next").children(".page-link").attr("onclick", "fn_list_show("+(page.endPage + 1)+")");
			}
			
		}
	});
}
/* ................기본정보 리스트를 조회한다.(end).............. */
/* ...................기본정보 클릭을 한다(start)................... */
$(function() {
	$("#list_ajax").on("click", "tr", function(){
		let formData = {
				"emp_no" 	 : $(this).children("td:eq(0)").text(),
				"emp_name" : $(this).children("td:eq(1)").text(),
				"emp_rank" : $(this).children("td:eq(2)").text()
			}
		
		// 클릭 후 상세조회 성공시, 기본정보 테이블 스타일을 변경한다
		if( fn_info_show(formData) == "okay" ) {
			$("#list_ajax tr").not(this).removeClass("table-info");
			$(this).addClass("table-info");
		}
	})
});
/* ...................기본정보 클릭을 한다(end)................... */
/* ...................상세정보 조회를 한다{인적사항, 학력정보, 경력정보}(start)................... */
function fn_info_show(formData) {	
	formData	// emp_no, emp_name, emp_rank 값이 담겨있다.
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
		url : "${pageContext.request.contextPath}/emp/info.do",
		type : "POST",
		dataType : "json",
		data : formData,	
		success : function(result) {
			console.log("상세정보 ajax 조회 성공");
			/* ...............인적사항(start)...................  */
			let info = result.info;
			// 상세정보 폼 안의 값을 초기화 시킨다.
			$("#emp_info_form")[0].reset();
			// 조회한 상세정보 값을 출력한다.
			// input emp_no 가 disabled 옵션이므로 데이터 저장을 위해 data 옵션을 사용한다.
			$("#emp_no").data("emp_no", info.emp_no);
			$("input[name=emp_no]").val(info.emp_no);
			$("input[name=emp_name]").val(info.emp_name);
			$("input[name=emp_jumin]").val(info.emp_jumin);
			$("input[name=emp_birth]").val(info.emp_birth);
			$("input[name=emp_phone]").val(info.emp_phone);
			$("input[name=emp_company_phone]").val(info.emp_company_phone);
			info.emp_company_email = info.emp_company_email.split("@");
			$("input[name=emp_company_email]").val(info.emp_company_email[0]);
			$("input[name=emp_personal_email]").val(info.emp_personal_email);
			$("input[name=emp_zip_code]").val(info.emp_zip_code);
			$("input[name=emp_addr1]").val(info.emp_addr1);
			$("input[name=emp_addr2]").val(info.emp_addr2);
			$("input[name=emp_period_start]").val(info.emp_period_start);
			$("input[name=emp_period_end]").val(info.emp_period_end);
			$("input[name=emp_join_start]").val(info.emp_join_start);
			$("input[name=emp_join_end]").val(info.emp_join_end);
//		$("input[name=emp_photo]").val();

			$("input[name=new_chk]:input[value=1]").prop("checked", false);
			$("input[name=emp_gender]:input[value="+info.emp_gender+"]").prop("checked", true);
			$("input[name=emp_calendar]:input[value="+info.emp_calendar+"]").prop("checked", true);
		 	$("input[name=emp_period_chk]:input[value="+info.emp_period_chk+"]").prop("checked", true);
		 	
			$("select[name=emp_rank]").val(info.emp_rank);
			$("select[name=emp_position]").val(info.emp_position);
			$("select[name=emp_contract]").val(info.emp_contract);
			$("select[name=emp_work]").val(info.emp_work);
			/* ...............인적사항(end)...................  */
			/* ...............학력사항(start)...................  */
			let edu = result.edu;
			if(edu.length > 0) {
				let htmls = "";
				htmls += "<tr>"
				htmls += "<td><input type='checkbox' name='edu_chk'><input type='hidden' name='edu_no' id='edu_no'></td>"
	  		htmls += "<td>"
				htmls += "	<input onclick='javascript:fn_datepicker(this);' name='edu_start' id='edu_start' class='datepicker datepicker2 form-control form-control-sm'>"
				htmls += "	<div class='invalid-feedback'>test</div>"
				htmls += "</td>"
				htmls += "<td>"                                                                                                 
				htmls += "	<input onclick='javascript:fn_datepicker(this);' name='edu_end' id='edu_end' class='datepicker datepicker2 form-control form-control-sm'>"
				htmls += "	<div class='invalid-feedback'>test</div>"                                                           
				htmls += "</td>"      
				htmls += "<td>"                                                                                                 
				htmls += "	<input name='edu_school' id='edu_school' class='form-control form-control-sm' type='text'>"
				htmls += "	<div class='invalid-feedback'>test</div>"                                                           
				htmls += "</td>"                   
				htmls += "<td>"                                                                                                 
				htmls += "	<input name='edu_major' id='edu_major' class='form-control form-control-sm' type='text'>"
				htmls += "	<div class='invalid-feedback'>test</div>"                                                           
				htmls += "</td>"               
				htmls += "<td>"                                                                                                 
				htmls += "	<select name='edu_degree' id='edu_degree' class='form-control form-control-sm'>"          
				htmls += "	<option value=''>--선택--</option>"       
				htmls += "	<option value='학사'>학사</option>"       
				htmls += "	<option value='석사'>석사</option>"       
				htmls += "	<option value='박사'>박사</option>"    
				htmls += "	</select>"        
				htmls += "	<div class='invalid-feedback'>test</div>"                                                           
				htmls += "</td>"                
				htmls += "<td>"                                                                                                 
				htmls += "	<select name='edu_status' id='edu_status' class='form-control form-control-sm'>"          
				htmls += "	<option value=''>--선택--</option>"       
				htmls += "	<option value='졸업'>졸업</option>"       
				htmls += "	<option value='졸업예정'>졸업예정</option>"       
				htmls += "	<option value='휴학'>휴학</option>"    
				htmls += "	</select>"        
				htmls += "	<div class='invalid-feedback'>test</div>"                                                           
				htmls += "</td>"                        
				htmls += "</tr>"
				$("#edu_ajax").html("");
				edu.forEach(function(edu, index){
					$("#edu_ajax").append(htmls);
					$("input[name=edu_no]:eq("+index+")").val(edu.edu_no)
					$("input[name=edu_start]:eq("+index+")").val(edu.edu_start)
					$("input[name=edu_end]:eq("+index+")").val(edu.edu_end)
					$("input[name=edu_school]:eq("+index+")").val(edu.edu_school)
					$("input[name=edu_major]:eq("+index+")").val(edu.edu_major)
					$("select[name=edu_degree]:eq("+index+")").val(edu.edu_degree)
					$("select[name=edu_status]:eq("+index+")").val(edu.edu_status)
				});
			} else {
				$("#edu_ajax").html("");
			}			
			/* ...............학력사항(end)...................  */
		}
	});

	return "okay";
}
/* ...................상세정보 조회를 한다{인적사항, 학력정보, 경력사항}(end)................... */
/* ..........신규직원 체크박스를 클릭한다.(start)......... */
	$("#new_chk").click(function(){
		let checked = $("#new_chk").is(":checked");
		if(checked) {
			$("#emp_no").attr("readonly", true);
		} else if(!checked) {
			$("#emp_no").attr("readonly", false);
		}
	})
/* ..........신규직원 체크박스를 클릭한다.(end)......... */
/* ...................인적사항 저장 버튼을 클릭한다(start)................. */
$(function(){
	$("#save_btn").click(function(){
		fn_save();
	})
});
/* ...................인적사항 저장 버튼을 클릭한다(end)................. */
/* ................인적사항 저장 버튼을 클릭을 실행한다(start)................  */
function fn_save() {
	console.log("fn_save() 저장 버튼 ajax 실행");
	
	// 인적사항의 form 정보를 저장한다.
	let formData = $("#emp_info_form").serialize();
	// input emp_no 가 disabled 옵션이므로 데이터 저장을 위해 data 옵션을 사용한다.
	formData += "&emp_no="+ $("#emp_no").data("emp_no");
	console.log(formData)
	
	jQuery.ajaxSettings.traditional = true;
	$.ajax({
		url : "${pageContext.request.contextPath}/emp/save.do",
		type : "POST",
		dataType : "json",
		data : formData,		
		success : function(result){
			console.log("fn_save() 저장 버튼 ajax 성공");
			console.log(result.null_list);
			console.log(result.error_list);
			
			if(result.state == "save") {
				alert("저장 완료");
			} else if(result.state == "update") {
				alert("수정 완료");
			}

			// 유효성 체크 경고 css 초기화
			$("input").removeClass("is-invalid");
			$("select").removeClass("is-invalid");

			// null 체크 경고 css 추가
			if(result.null_list.length != 0) {
				result.null_list.forEach(function(list){
					$("input[name="+list+"]").addClass("is-invalid");
					$("input[name="+list+"]").nextAll(".invalid-feedback").text("값을 입력해주세요.");
					$("select[name="+list+"]").addClass("is-invalid");
					$("select[name="+list+"]").nextAll(".invalid-feedback").text("값을 선택해주세요.");
				});
			}
			// 유효성 체크 경고 css 추가
			if(result.error_list.length != 0) {
				result.error_list.forEach(function(list){
					$("input[name="+list.value+"]").addClass("is-invalid");
					$("input[name="+list.value+"]").nextAll(".invalid-feedback").text(list.msg);
					$("select[name="+list.value+"]").addClass("is-invalid");
					$("select[name="+list.value+"]").nextAll(".invalid-feedback").text(list.msg);
				});
			}
		}
	});
}
/* ................인적사항 저장 버튼을 클릭을 실행한다(end)................  */
/* ................학력정보 행추가 버튼 클릭을 한다(start)................... */
$(function(){
	const row_htmls = $("#edu_ajax").html()
	$("#edu_ajax").html("")
	$("#row_add_btn").on("click", function(){
		$("#edu_ajax").append(row_htmls)
	});	
});
/* ................학력정보 행추가 버튼 클릭을 한다(end)................... */
/* ................학력정보 행삭제 버튼 클릭을 한다(start)................... */
$(function(){
	$("#row_del_btn").on("click", function(){
		// 체크된 행들을 삭제한다.
		$("input[name=edu_chk]:checked").each(function(index){
			$(this).parents("tr").remove()
		});
		// 전체체크를 해제한다.
		$("#edu_chk_all").prop("checked", false)
	});
});
/* ................학력정보 행삭제 버튼 클릭을 한다(end)................... */
/* ................학력정보 체크박스 전체선택을 한다(start)................... */
$(function(){
	$("#edu_chk_all").on("click", function(){
		if( $("#edu_chk_all").is(":checked") ) 
			$("input[name=edu_chk]").prop("checked", true)
		else 
			$("input[name=edu_chk]").prop("checked", false)
	});
});
/* ................학력정보 체크박스 전체선택을 한다(end)................... */
/* ........학력정보 저장 버튼을 클릭한다(start).......... */
function fn_edu_save() {
	console.log("fn_edu_save() 저장 버튼 ajax 실행");
			
	let totData = new Object;
	let dataList = new Array();
	$("#edu_ajax tr").each(function(index){
		let data = new Object;
		data["edu_no"] = $("input[name=edu_no]").eq(index).val()
		data["edu_start"] = $("input[name=edu_start]").eq(index).val()
		data["edu_end"] = $("input[name=edu_end]").eq(index).val()
		data["edu_school"] = $("input[name=edu_school]").eq(index).val()
		data["edu_major"] = $("input[name=edu_major]").eq(index).val()
		data["edu_degree"] = $("select[name=edu_degree]").eq(index).val()
		data["edu_status"] = $("select[name=edu_status]").eq(index).val()
		dataList.push(data)
	});
	totData["edu_list"] = dataList;
	totData["emp_no"] = $("#emp_no").val();
	
	console.log(totData)
			 
	//jQuery.ajaxSettings.traditional = true;
	$.ajax({
	 url : "${pageContext.request.contextPath}/emp/edu_save.do",
	 type : "POST",
	 dataType : "json",
	 contentType: 'application/json; charset=utf-8',
	 data : JSON.stringify(totData),
	 success : function(result) {
		 if(result.state == "true") {
			 console.log("학력정보 저장 성공")
		 }
	 }
	});
}
/* ........학력정보 저장 버튼을 클릭한다(end).......... */
/* .......일정 달력(start) ....... */
function fn_datepicker(obj) {
	$( obj ).datepicker({
		  dateFormat: 'yy-mm-dd',
		  prevText: '이전 달',
		  nextText: '다음 달',
		  monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		  monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		  dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		  dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		  showMonthAfterYear: true,
		  yearSuffix: '년',
		  changeYear: true, 
		  changeMonth: true,
		  yearRange : 'c-10:c+2'
	}).datepicker("show");
}
/* .......일정 달력(end) ....... */







/* 도로명 주소 api */
//opener관련 오류가 발생하는 경우 아래 주석을 해지하고, 사용자의 도메인정보를 입력합니다. ("팝업API 호출 소스"도 동일하게 적용시켜야 합니다.)
//document.domain = "abc.go.kr";

function goPopup(){
	// 주소검색을 수행할 팝업 페이지를 호출합니다.
	// 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://www.juso.go.kr/addrlink/addrLinkUrl.do)를 호출하게 됩니다.
/* 	let width = 600;
	let height = 600;
	let left = ($("body").offset().left / 2) - 300
	let tops = ($("body").offset().top / 2) + 300
	console.log(tops)
	left += window.screenLeft;
	tops += window.screenTop; */
	let left = window.screenLeft + $("#emp_zip_code").offset().left;
	let top = window.screenTop + ($("#emp_zip_code").offset().top / 2);
	let pop = window.open("/emp/post_road.do","pop","width=600,height=600, scrollbars=yes, resizable=yes, left="+left+",top="+top); 
	
	// 모바일 웹인 경우, 호출된 페이지(jusopopup.jsp)에서 실제 주소검색URL(https://www.juso.go.kr/addrlink/addrMobileLinkUrl.do)를 호출하게 됩니다.
  //var pop = window.open("/popup/jusoPopup.jsp","pop","scrollbars=yes, resizable=yes"); 
}
function jusoCallBack(roadFullAddr,roadAddrPart1,addrDetail,roadAddrPart2,engAddr, jibunAddr, zipNo, admCd, rnMgtSn, bdMgtSn,detBdNmList,bdNm,bdKdcd,siNm,sggNm,emdNm,liNm,rn,udrtYn,buldMnnm,buldSlno,mtYn,lnbrMnnm,lnbrSlno,emdNo){
		$("#emp_addr1").val(roadAddrPart1 + " " + roadAddrPart2);
		$("#emp_addr2").val(addrDetail);
		$("#emp_zip_code").val(zipNo);
}


/* .......................$(function()............................... */
$(function() {
	/* 생년월일 달력 데이터 설정 */
	$("#emp_birth").datepicker({
	  dateFormat: 'yy-mm-dd',
	  prevText: '이전 달',
	  nextText: '다음 달',
	  monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	  monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	  dayNames: ['일', '월', '화', '수', '목', '금', '토'],
	  dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
	  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
	  showMonthAfterYear: true,
	  yearSuffix: '년',
	  changeYear: true, 
	  changeMonth: true,
	  yearRange : 'c-50:c'
	});
	/* 기간 달력 데이터 설정 */
 	$(".datepicker2").datepicker({
	  dateFormat: 'yy-mm-dd',
	  prevText: '이전 달',
	  nextText: '다음 달',
	  monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	  monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	  dayNames: ['일', '월', '화', '수', '목', '금', '토'],
	  dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
	  dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
	  showMonthAfterYear: true,
	  yearSuffix: '년',
	  changeYear: true, 
	  changeMonth: true,
	  yearRange : 'c-10:c+2'
	});
});

/* 더미 데이터  */
$(function(){
	$("input[name=emp_no]").val();
	$("input[name=new_chk]:input[value=1]").prop("checked", true);
	$("input[name=emp_name]").val("홍길동");
	$("input[name=emp_jumin]").val("820805-1155423");
	$("input[name=emp_gender]:input[value=1]").prop("checked", true);
	$("input[name=emp_birth]").val("1990-01-01");
	$("input[name=emp_calendar]:input[value=1]").prop("checked", true);
	$("input[name=emp_phone]").val("010-5512-5512");
	$("input[name=emp_company_phone]").val("02-551-5512");
	$("input[name=emp_company_email]").val("test123");
	$("input[name=emp_personal_email]").val("test123@naver.com");
	$("input[name=emp_zip_code]").val("21377");
	$("input[name=emp_addr1]").val("인천광역시 부평구 안남로206번길 46-5 (산곡동)");
	$("input[name=emp_addr2]").val("상세주소 테스트");
	$("select[name=emp_rank]").val("1");
	$("select[name=emp_position]").val("1");
	$("select[name=emp_contract]").val("1");
	$("select[name=emp_work]").val("1");
 	$("input[name=emp_period_chk]:input[value=1]").prop("checked", true);
	$("input[name=emp_period_start]").val("2022-01-01");
	$("input[name=emp_period_end]").val("2022-03-01");
	$("input[name=emp_join_start]").val("2022-01-01");
	$("input[name=emp_join_end]").val();
//	$("input[name=emp_photo]").val();
});
	

		</script>

    <title>업무포탈</title>
  </head>
  <body>
    
    <div class="d-flex">
    	<!-- nav -->
   		<div class="p-2 float-left border-right" style="width: 200px; position: fixed; height: 100vh; background-color: #363636; color:white">
   			<div>
   				로고
   			</div>
   			<div>
   				<div>로그인</div>
   				<div>회원가입</div>
   			</div>
   			<hr>
   			<ul class="list-group">
   				<li><a href="#none">인사관리</a></li>
   				<li><a href="#none">근태관리</a></li>
   				<li><a href="#none">급여관리</a></li>
   			</ul>
   		</div>
   		
   		<!-- container -->
   		<div class="p-2 flex-grow-1 inner" style="font-size: 12px; margin-left: 200px; background-color: #fff; max-height:100%; min-height: 100vh;">
   			<h5 class="p-2">인사정보등록</h5>
   			<hr>
   			<!-- 기본정보 -->
   			<div class="table-responsive">
   				<div style="display: flex; justify-content: center; align-items: center; background-color: #f5f5f5; max-width:100%; height: 50px; margin: 10px 5px;">
	  				<select name="searchType" id="searchType" class="form-control form-control-sm">
						  <option value="name">성명</option>
					  	<option value="rank">직급</option>
					  	<option value="position">직책</option>
						</select>
						<input type="text" id="keyword" name="keyword" class="form-control form-control-sm m-1" style="max-width:25%;">
   					<button type="button" class="btn btn-dark btn-sm" onclick="fn_search()">검색</button>
   				</div>
   				<h6>기본정보</h6>
   				<table class="table table-sm table-bordered w-auto">
   					<thead>
   						<tr>
   							<th>사원번호</th>
   							<th>성명</th>
   							<th>직급</th>
   							<th>직책</th>
   							<th>입사일자</th>
   							<th>핸드폰</th>
   							<th>계약기준</th>
   							<th>재직구분</th>
   						</tr>
   					</thead>
   					<tbody id="list_ajax">
   					</tbody>
   				</table>
   				<div>
   				  <ul id="" class="pagination pagination-sm">
					    <li id="page_prev" class="page-item disabled">
					      <a class="page-link" href="#none">이전</a>
					    </li>
					    <li>
						    <ul id="page_ajax" class="pagination pagination-sm">
						   		<li class="page-item"><a class="page-link" href="#">1</a></li>
						   	</ul>
						  </li>
					    <li id="page_next" class="page-item">
					      <a class="page-link" href="#none">다음</a>
					    </li>
					  </ul>
   				</div>
   			</div>
   			<!-- 상세정보 -->
   			<hr>
   			<div>
   				<h6>상세정보</h6>
   				<div>
   					<!-- tab 메뉴 -->
						<ul class="nav nav-tabs" id="myTab" role="tablist">
						  <li class="nav-item" role="presentation">
						    <a class="nav-link active" id="home-tab" data-toggle="tab" 
						    href="#tab1" role="tab" aria-controls="tab1" aria-selected="true">인적사항</a>
						  </li>
						  <li class="nav-item" role="presentation">
						    <a class="nav-link" id="profile-tab" data-toggle="tab" 
						    href="#tab2" role="tab" aria-controls="tab2" aria-selected="false">학력정보</a>
						  </li>
						  <li class="nav-item" role="presentation">
						    <a class="nav-link" id="contact-tab" data-toggle="tab" 
						    href="#tab3" role="tab" aria-controls="tab3" aria-selected="false">경력정보</a>
						  </li>
						</ul>
						<!-- tab 내용 -->
						<div class="tab-content" id="myTabContent">
							<!-- 인적사항 -->
						  <div class="p-2 tab-pane fade show active" id="tab1" role="tabpanel" aria-labelledby="tab1-tab">
						  	<!-- emp_form -->
						  	<form id="emp_info_form" name="emp_info_form">
							  <div>
							  	<table class="table table-sm table-bordered">
							  		<tr>
							  			<td rowspan="5" style="text-align: center;">
							  				<img src="${pageContext.request.contextPath}/images/btn_date.png" class="img-thumbnail" alt="..." style="width: 103px; height: 132px;">
							  			</td>
							  		</tr>
							  		<tr>
							  			<th>사원번호</th>
							  			<td width="30%">
							  				<input name="emp_no" class="form-control form-control-sm custom-control-inline" type="text" id="emp_no" disabled>
							  				<input name="new_chk" type="checkbox" id="new_chk" value="1">
							  				<label for="new_chk">신규직원</label>
							  				<div class="invalid-feedback">test</div>
							  			</td>
							  			<th>성명</th>
							  			<td>
							  				<input name="emp_name" id="emp_name" class="form-control form-control-sm" type="text">
							  				<div class="invalid-feedback">test</div>
							  			</td>
							  		</tr>
							  		<tr>
							  			<th>주민등록번호</th>
							  			<td>
							  				<input name="emp_jumin" id="emp_jumin" placeholder="예)920902-1234567" class="form-control form-control-sm" type="text">
							  				<div class="invalid-feedback">test</div>
							  			</td>
							  			<th>성별</th>
							  			<td>
							  				<div style="display: flex">
									  			<div class="custom-control custom-radio mr-3">
													  <input type="radio" id="emp_gender1" name="emp_gender" value="1" class="custom-control-input">
													  <label class="custom-control-label" for="emp_gender1">여성</label>
													  <div class="invalid-feedback">test</div>
													</div>
													<div class="custom-control custom-radio">
													  <input type="radio" id="emp_gender2" name="emp_gender" value="2" class="custom-control-input" style="width: 100%">
													  <label class="custom-control-label" for="emp_gender2">남성</label>
													</div>
												</div>
							  			</td>
							  		</tr>
							  		<tr>
							  			<th>생년월일</th>
							  			<td>
							  				<input class="datepicker form-control form-control-sm" name="emp_birth" id="emp_birth">
							  				<div class="invalid-feedback">test</div>
							  			</td>
							  			<th>양력 음력</th>
							  			<td>
							  				<div style="display: flex">
									  			<div class="custom-control custom-radio mr-3">
													  <input type="radio" id="emp_calendar1" name="emp_calendar" value="1" class="custom-control-input">
													  <label class="custom-control-label" for="emp_calendar1">양력</label>
													  <div class="invalid-feedback">test</div>
													</div>
													<div class="custom-control custom-radio mr-3">
													  <input type="radio" id="emp_calendar2" name="emp_calendar" value="2" class="custom-control-input">
													  <label class="custom-control-label" for="emp_calendar2">음력</label>
													</div>
												</div>
											</td>
							  		</tr>
							  		<tr>
							  			<th>핸드폰</th>
							  			<td>
							  				<input class="form-control form-control-sm" name="emp_phone" id="emp_phone" type="text" placeholder="010-1234-5678">
							  				<div class="invalid-feedback">test</div>
							  			</td>
							  			<th>회사전화</th>
							  			<td>
							  				<input class="form-control form-control-sm" name="emp_company_phone" id="emp_company_phone" type="text" placeholder="032-123-4567">
							  				<div class="invalid-feedback">test</div>
							  			</td>
							  		</tr>
							  	</table>
						  	</div>
						  	<div>
					  			<table class="table table-sm table-bordered">
							  		<tr>
							  			<th>회사이메일</th>
							  			<td>
								  			<div class="input-group input-group-sm" style="width: 50%">
												  <input name="emp_company_email" id="emp_company_email" type="text" class="form-control" placeholder="아이디만 입력하세요.">
												  <div class="input-group-append">
												    <span class="input-group-text">@company.co.kr</span>
												  </div>
												  <div class="invalid-feedback">test</div>
												</div>
							  			</td>
							  		</tr>
							  		<tr>
							  			<th>외부이메일</th>
							  			<td>
							  				<input name="emp_personal_email" id="emp_personal_email" class="form-control form-control-sm" type="text" style="max-width: 80%">
							  				<div class="invalid-feedback">test</div>
							  			</td>
							  		</tr>
							  		<tr>
							  			<th>자택주소</th>
							  			<td>
							  				<div class="d-flex">
						  						<div class="input-group" style="width: auto;">
													 	<input name="emp_zip_code" id="emp_zip_code" type="text" class="form-control form-control-sm">
														<div class="input-group-append" style="z-index: 0">
															<button class="btn btn-outline-secondary btn-sm"
																type="button" id="emp_addr_search" onClick="goPopup();">검색</button>
														</div>
														<div class="invalid-feedback">test</div>
													</div>
													<div style="width: 100%">
								  					<input name="emp_addr1" id="emp_addr1" class="form-control form-control-sm" type="text" style="max-width: 80%; margin-left: 5px;">
							  						<div class="invalid-feedback">test</div>
							  					</div>
							  				</div>
							  				<div style="margin-top: 5px;">
							  					<input name="emp_addr2" id="emp_addr2" class="form-control form-control-sm" type="text" style="display: inline-block; max-width: 80%;">
							  					<div class="invalid-feedback">test</div>
							  				</div>
							  			</td>
							  		</tr>
							  	</table>
						  	</div>
						  	<div>
					  			<table class="table table-sm table-bordered">
							  		<tr>
							  			<th>직급</th>
							  			<td>
							  				<select name="emp_rank" id="emp_rank" class="form-control form-control-sm">
												  <option value="">--선택--</option>
												  <c:forEach var="list" items="${emp_rank}">
												  	<option value="${list.emp_rank_code}">${list.emp_rank_name}</option>
												  </c:forEach>
												</select>
												<div class="invalid-feedback">test</div>
							  			</td>
							  			<th>계약기준</th>
							  			<td>
												<select name="emp_contract" id="emp_contract" class="form-control form-control-sm">
												  <option value="">--선택--</option>
												  <c:forEach var="list" items="${emp_contract}">
												  	<option value="${list.emp_contract_code}">${list.emp_contract_name}</option>
												  </c:forEach>
												</select>
							  			</td>
							  		</tr>
							  		<tr>
							  			<th>직책</th>
							  			<td>
												<select name="emp_position" id="emp_position" class="form-control form-control-sm">
												  <option value="">--선택--</option>
												  <c:forEach var="list" items="${emp_position}">
												  	<option value="${list.emp_position_code}">${list.emp_position_name}</option>
												  </c:forEach>
												</select>
												<div class="invalid-feedback">test</div>
											</td>
							  			<th>재직구분</th>
							  			<td>
							  				<select name="emp_work" id="emp_work" class="form-control form-control-sm">
												  <option value="">--선택--</option>
												  <c:forEach var="list" items="${emp_work}">
												  	<option value="${list.emp_work_code}">${list.emp_work_name}</option>
												  </c:forEach>
												</select>
												<div class="invalid-feedback">test</div>
											</td>
							  		</tr>
							  		<tr>
							  			<th>수습여부</th>
							  			<td>
							  				<input name="emp_period_chk" id="emp_period_chk" value="1" type="checkbox">
							  				<label for="emp_period_chk">수습기간</label>
							  			</td>
							  			<th>수습기간</th>
							  			<td>
							  				<input name="emp_period_start" id="emp_period_start" class="datepicker datepicker2 form-control form-control-sm"> 
							  				- <input name="emp_period_end" id="emp_period_end" class="datepicker datepicker2 form-control form-control-sm">
							  			</td>
							  		</tr>
							  		<tr>
							  			<th>입사일자</th>
							  			<td>
								  			<input name="emp_join_start" id="emp_join_start" class="datepicker datepicker2 form-control form-control-sm">
												<div class="invalid-feedback">test</div>
							  			</td>
							  			<th>퇴직일자</th>
							  			<td>
							  				<input name="emp_join_end" id="emp_join_end" class="datepicker datepicker2 form-control form-control-sm">
							  				<div class="invalid-feedback">test</div>
							  			</td>
							  		</tr>
							  	</table>
						  	</div>
				   			<!-- 버튼 -->
				   			<div class="d-flex justify-content-end">
				   				<button id="del_btn" type="button" class="btn btn-outline-dark btn-sm mr-1">삭제</button>
				   				<button id="out_btn" type="button" class="btn btn-danger btn-sm mr-1">퇴사자 등록</button>
				   				<button id="save_btn" type="button" class="btn btn-dark btn-sm mr-1">저장</button>
				   			</div>
				   			</form>
						  </div>
						  <!-- 학력정보 -->
						  <div class="p-2 tab-pane fade" id="tab2" role="tabpanel" aria-labelledby="tab2-tab">
						  	<div class="mb-2 d-flex justify-content-end">
						  		<button id="row_add_btn" type="button" class="mr-1 btn btn-outline-primary btn-sm">행추가</button>
						  		<button id="row_del_btn" type="button" class="mr-1 btn btn-outline-danger btn-sm">행삭제</button>
						  	</div>
						  	<div>
						  		<form id="edu_form" name="edu_form" >
						  		<table class="table table-sm table-bordered text-center">
										<thead>
							  			<tr>
							  				<th style="width: 50px !important;"><input type="checkbox" id="edu_chk_all"></th>
							  				<th>입학년월</th>
							  				<th>졸업년월</th>
							  				<th>학교명</th>
							  				<th>전공학과</th>
							  				<th>학위</th>
							  				<th>졸업구분</th>
							  			</tr>
							  		</thead>
							  		<tbody id="edu_ajax">
							  			<tr>
							  				<td>
							  					<input type="checkbox" name="edu_chk">
							  					<input type="hidden" name="edu_no" id="edu_no">
							  				</td>
							  				<td>
							  					<input name="edu_start" id="edu_start" class="datepicker form-control form-control-sm" onclick="fn_datepicker(this)">
													<div class="invalid-feedback">test</div>
							  				</td>
							  				<td>
							  					<input name="edu_end" id="edu_end" class="datepicker form-control form-control-sm" onclick="fn_datepicker(this)">
													<div class="invalid-feedback">test</div>
							  				</td>
							  				<td>
							  					<input name="edu_school" id="edu_school" class="form-control form-control-sm" type="text">
								  				<div class="invalid-feedback">test</div>
							  				</td>
							  				<td>
							  					<input name="edu_major" id="edu_major" class="form-control form-control-sm" type="text">
								  				<div class="invalid-feedback">test</div>
							  				</td>
							  				<td>
								  				<select name="edu_degree" id="edu_degree" class="form-control form-control-sm">
													  <option value="">--선택--</option>
													  <option value="학사">학사</option>
													  <option value="석사">석사</option>
													  <option value="박사">박사</option>
													</select>
													<div class="invalid-feedback">test</div>
							  				</td>
							  				<td>
								  				<select name="edu_status" id="edu_status" class="form-control form-control-sm">
													  <option value="">--선택--</option>
													  <option value="졸업">졸업</option>
													  <option value="졸업예정">졸업예정</option>
													  <option value="휴학">휴학</option>
													</select>
													<div class="invalid-feedback">test</div>
							  				</td>
							  			</tr>
							  		</tbody>
							  	</table>
							  	</form>
						  	</div>
						  	<hr>
						  	<div class="mb-2 d-flex justify-content-end">
						  		<button type="button" class="btn btn-dark btn-sm" onclick="fn_edu_save();">저장</button>
						  	</div>
						  </div>
						  <!-- 경력정보 -->
						  <div class="p-2 tab-pane fade" id="tab3" role="tabpanel" aria-labelledby="tab3-tab">...</div>
						</div>
   				</div>
   			</div>
   		</div>
    </div>
    
    <!-- footer -->
    <footer>
    	<div class="container"></div>
    </footer>

  </body>
</html>