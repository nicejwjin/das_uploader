$(function(){

	/*
	$(".sub_con .side_menu > ul").mouseenter(function(){
		$(this).find("a").css("display","block")
		$(".sub_con .side_menu").width(270);
	}).mouseleave(function(){
		$(".sub_con .side_menu > ul > li > a").removeClass("on")
		$(".sub_con .side_menu a,.sub_con .side_menu .sub_list").hide();
		$(".sub_con .side_menu").width(70);
	});
	$(".sub_con .side_menu > ul > li > a").mouseenter(function(){
		$(".sub_con .side_menu > ul > li > a").removeClass("on")
		$(this).addClass("on")
		$(".sub_con .side_menu .sub_list").hide();
		$(this).next().css("display","block");
	});	
	*/

	// select box 2014-06-26
	$(".select").click(function(e) {
		
		if($(this).hasClass("select_on")) {
			if (e.target.nodeName=="LI" || e.target.nodeName=="li") {
				$(this).find("select").val($(e.target).data("val"));
				$(this).find("span").text($(e.target).text());
				$(this).removeClass("select_on");
				$(e.target).parent().next().change();
			}
			$(this).removeClass("select_on");

		}else {
			$(".select_on").removeClass("select_on");
			$(this).addClass("select_on");
		}
	});

	$(".select select").change(function() {
		var text = $(this).find(":checked").text();
		$(this).parents(".select").find("span").text(text);
	});

	$("body").bind("click", function(e) {
		if($(e.target).parents(".select").size() == 0 && !$(e.target).hasClass("select")) {
			$(".select_on").removeClass("select_on");
		}else {
			
		}

		if($(e.target).parents(".select_check").size() == 0 && !$(e.target).hasClass("select_check")) {
			$(".select_check_on").removeClass("select_check_on");
		}

		if($(e.target).parents(".help").size() == 0 && !$(e.target).hasClass("help")) {
			$(".help_on").removeClass("help_on");
		}
	});

	$(".tform01 .result").each(function(){
		if($(this).text() == "성공"){
			$(this).css("color","#46ddff")
		}else if($(this).text() == "실패"){
			$(this).css("color","#f6809c").parents("tr").find(".btn_rfsh").css("display","inline-block");
		}else if($(this).text() == "대기"){
			$(this).css("color","#abafb2")
		}
	})



	//placeholder 2014-06-27
	if(!("placeholder" in document.createElement("input"))) {
		$("input[placeholder], textarea[placeholder]").each(function(i) {
			if($(this).val() == "") {
				$(this).addClass("placeholder").val($(this).attr("placeholder")).addClass("none");
			}
			$(this).focus(function(){
				if($(this).hasClass("placeholder")) {
					$(this).val("").removeClass("placeholder");
				}
			}).blur(function() {
				if($(this).val() == "") {
					$(this).addClass("placeholder");
					$(this).val($(this).attr("placeholder"));
				}else {
					$(this).removeClass("none");
				}
			});
		});
	}
	
	$(".btn_box .btn_inner").click(function(){
		$(".btn_box .btn_inner").removeClass("on");
		$(this).addClass("on");
		return false;
	});
	$(".tab li").click(function(){
		$(".tab li").removeClass("on");
		$(this).addClass("on");
	})
	
	function table_bg(){
		$(".tform01 table tbody tr th,.tform01 table tbody tr td").css("background-color","");
		$(".tform01 table tbody tr:nth-child(2n) th,.tform01 table tbody tr:nth-child(2n) td").css("background-color","#fff");
	}table_bg();
	
	// 파일첨부 2014-08-18 수정
	$(".btn_add_file input").live("change", function(e) {
		var $wrap = $(this).parent();
		var name = $(this).val();
		var $file_list = $(this).parent().next();
		if($file_list.find("li").size() < 5) {
			var li = $("<li><span>"+name+"</span><a href='#'><img src='/resources/images/btn_del.png' alt='삭제' /></a></li>");
			//li.clone($(this));
			$file_list.append(li);
			//$wrap.html("파일찾기<input type='file' /> ");
			$wrap.after('<span class="btn_add_file">파일찾기<input type="file" id="UPLOAD_FILE_INFO" name="files"></span>')
			$(".add_file > .btn_add_file").not(":last").hide();
		}else {
			alert("파일은 최대 5개까지 등록 가능합니다.");
			//$wrap.html("파일찾기<input type='file' /> ");
		};
		file_txt();
	});

	/*	  라디오 2014-06-24 */
	$(".radio input").live("change", function() {
		var r_name = $(this).attr("name");
		$("input[name="+r_name+"]").parent().removeClass("radio_on");
		$(this).parent().addClass("radio_on");
	});

	//체크  2014-06-24
	$(".checkbox input").live("change", function() {
		if($(this).prop("checked")) {
			$(this).parent().addClass("checkbox_on");
		} else {
			$(this).parent().removeClass("checkbox_on");
		}
	});
	
	
	$(".btn_file input").change(function() {
		var name = $(this).val();
		$(this).parent().prev().text(name);
	});
	

	function agent_info(){
		var tr_size;
		$(document).on("click",".agent_info .btn_list_add",function(){
		var tr = '<tr>'
					+'<td>1</td>'
					+'<td><input type="text" class="ip_txt" style="width:206px"></td>'
					+'<td><input type="text" class="ip_txt" style="width:206px"></td>'
					+'<td><label class="checkbox"><input type="checkbox" class="">파일 삭제</label></td>'
					+'<td><a href="#" class="btns btn_inner90 btn_list_del"><span><strong>-</strong> 항목 삭제</span></a></td>'
					+'</tr>';
			$(this).parents(".tform01").find("table tbody").append(tr);
			table_bg();
			table_num();
			return false;
		});
		$(document).on("click",".agent_info .btn_list_del",function(){
			$(this).parents("tr").remove();
			table_bg();
			table_num();
			
			return false;
		});
		function table_num(e){
			$(".agent_info table tbody tr").each(function(){
				$(this).find("td:first").text($(this).index() + 1)
			})
		}	
	}agent_info();

	

	$(".ui-datepicker-trigger").mouseenter(function(){
		$(this).attr("src",$(this).attr("src").replace(".png","_on.png"))
	}).mouseleave(function(){
		$(this).attr("src",$(this).attr("src").replace("_on.png",".png"))
	});
	//캘린더
	$(".ip_date input").datepicker({
		showOn: "button",
		buttonImage: "./resources/images/btn_calendar.png",
		buttonImageOnly: true
	});

	$(".ip_date2 input").datepicker({
		showOn: "button",
		buttonImage: "./resources/images/btn_calendar2.png",
		buttonImageOnly: true
	});	
	
		
	if($("body").outerHeight() >= $(window).outerHeight() ){
		$("#footer").removeClass("over");
	}else{
		$("#footer").addClass("");
	};
	$(window).resize(function(){
		if($("body").outerHeight() >= $(window).outerHeight() ){
			$("#footer").removeClass("over");
			console.log("over")
		}else{
			$("#footer").addClass("over");
			console.log("not")
		};
	});
});

//N일 이전 날짜 구하기
function getMinusNDay(date, N) {
	var dateArr = date.split('-');
	var changeDate = new Date();
	
	var year = dateArr[0];
	var month = dateArr[1];
	var day = Number(dateArr[2])-N;
	
	changeDate.setFullYear(year, month-1, day);

    var changeYear = changeDate.getFullYear();
    var changeMonth = changeDate.getMonth() + 1;
    var changeDay = changeDate.getDate();

    // 날짜 포맷으로 변경
    if (changeMonth < 10) {
    	changeMonth = '0' + changeMonth;
    }
    if (changeDay < 10) {
    	changeDay = '0' + changeDay;
    }
    
	return changeYear + '-' + changeMonth + '-' + changeDay;
}

// N개월 이전의 1일 날짜 구하기
function getMinusNMonth(date, N) {
	var dateArr = date.split('-');
	
	var year = dateArr[0];
	var month = dateArr[1];
	var day = dateArr[2];
	
	var changeYear = year;
	var changeMonth = 0;
	var changeDay = day;   // Day를 1일로 설정
	
	// N>12보다 큰 경우, 년수를 빼준다
    changeYear -= Math.floor(N/12);   
	
	var mon = N % 12;
	
	// N개월 이전의 달과 연도 계산
	if (month > mon) {
		changeMonth = Number(month) - mon;
	} else {
		changeMonth = 12 + (Number(month) - mon);
		changeYear = Number(year) - 1;
	}
	
	// 날짜 포맷으로 변경
	if (changeMonth < 10) {
		changeMonth = '0' + changeMonth;
	}
	
	// Day를 1일로 설정
	changeDay = '01';   
	
	return changeYear + '-' + changeMonth + '-' + changeDay;
}

// N-1주전 월요일 날짜 구하기
function getMinusNWeek(date, N) {
	var dateArr = date.split('-');
	
	var year = dateArr[0];
	var month = dateArr[1];
	var day = dateArr[2];
	
	var vn_date = new Date(year, month -1, day);
	var i = vn_date.getDay();  // 기준일의 요일 구하기(0:일요일, 1:월요일, 2:화요일, 3:수요일, 4:목요일, 5:금요일, 6: 토요일)
 	if (i==0) {
 		dayCnt = -6;
 	} else {
 		dayCnt = 1-i;
 	}
	
	dayCnt -= 7*N; // N주 전 월요일
	
	var srt_date = new Date(vn_date.getFullYear(), vn_date.getMonth(), vn_date.getDate() + dayCnt);
	return srt_date.getFullYear() + "-" + valid_num(srt_date.getMonth() + 1) + "-" + valid_num(srt_date.getDate()); 
}

//두 날짜간 일수, 주수, 개월수 구하기
function getDayWeekMonthCnt(sday, eday, dateType) {
	sday = sday.replace(/-/gi,"");
	eday = eday.replace(/-/gi,"");
	
	var sdate = new Date(sday.substring(0,4), sday.substring(4,6)-1, sday.substring(6,8));
	var edate = new Date(eday.substring(0,4), eday.substring(4,6)-1, eday.substring(6,8));
	
	var termCnt=0;
	if (dateType == "DAY")
		termCnt=(edate.getTime() - sdate.getTime())/(1000*60*60*24) + 1; 
	else if (dateType == "WEEK") {
		termCnt=(edate.getTime() - sdate.getTime())/(1000*60*60*24*7) + 1;
	} else { // MONTH
		if (eday.substring(0,4) == sday.substring(0,4)) {
			termCnt = eday.substring(4,6) * 1 - sday.substring(4,6) * 1 +1; 
		} else {
			termCnt = (eday.substring(0,4) * 1 - sday.substring(0,4) * 1) * 12 + (eday.substring(4,6) * 1 - sday.substring(4,6) * 1) + 1;
		}
	}

	return Math.floor(termCnt); 
}

function getFsizeStr(fsize) {
	var unit = " Bytes";
	
	if (fsize >= 1024*1024*1024) {
		fsize /= 1024*1024*1024;
		fsize = fsize.toFixed(1);
		unit = " GBytes";
	} else if (fsize >= 1024*1024) {
		fsize /= 1024*1024;
		fsize = fsize.toFixed(1);		
		unit = " MBytes";		
	} else if (fsize >= 1024) {
		fsize /= 1024;
		fsize = fsize.toFixed(1);		
		unit = " KBytes";				
	} 
	
	return fsize+" "+unit; 
}