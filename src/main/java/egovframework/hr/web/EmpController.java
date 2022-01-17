package egovframework.hr.web;

import java.util.ArrayList;
import java.util.HashMap;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


import egovframework.hr.service.EduVO;
import egovframework.hr.service.EgovDateUtil;
import egovframework.hr.service.EgovFormatCheckUtil;
import egovframework.hr.service.EgovNumberCheckUtil;
import egovframework.hr.service.EgovNumberUtil;
import egovframework.hr.service.EgovStringUtil;
import egovframework.hr.service.EmpCheck;
import egovframework.hr.service.EmpCodeVO;
import egovframework.hr.service.EmpService;
import egovframework.hr.service.EmpVO;
import egovframework.hr.service.PageMaker;
import egovframework.hr.service.SearchCriteria;

@Controller
@RequestMapping(value = "/emp")
public class EmpController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
		
	@Resource(name = "empService")
	private EmpService empService;
	
	// 메인 페이지
	@RequestMapping(value = "/main.do")
	public String main( EmpCodeVO vo, ModelMap model ) throws Exception {
		logger.info("main.do 시작");
		
		/* ====== 코드 리스트 조회 ====== */
		/* ----------- 인적사항 ---------------- */
		// 직급 코드 리스트
		ArrayList<EmpCodeVO> emp_rank = empService.select_emp_rank();
		// 직책 코드 리스트
		ArrayList<EmpCodeVO> emp_position = empService.select_emp_position();
		// 계약기준 코드 리스트
		ArrayList<EmpCodeVO> emp_contract = empService.select_emp_contract();
		// 재직구분 코드 리스트
		ArrayList<EmpCodeVO> emp_work = empService.select_emp_work();
		
		/* ====== view에 전달 ====== */
		model.addAttribute("emp_rank", emp_rank);
		model.addAttribute("emp_position", emp_position);
		model.addAttribute("emp_contract", emp_contract);
		model.addAttribute("emp_work", emp_work);
		
		return "emp/main";
	}
	
	// 인사 기본정보 리스트 출력
	@ResponseBody
	@RequestMapping(value = "/list.do", method=RequestMethod.POST)
	public HashMap<String, Object> list( EmpVO vo, SearchCriteria sri ) throws Exception {
		logger.info("인사 기본정보 리스트 메서드 실행");
		HashMap<String, Object> result = new HashMap<>();	// 결과 반환할 해쉬맵
		ArrayList<EmpVO> list = new ArrayList<>(); 	// 인사 정보를 저장할 리스트
		String state = "false";	// 결과 정보
		PageMaker pageMaker = new PageMaker(); // 페이징 처리 위한 객체 선언
		
		/* ====== DB 처리 ====== */
		// list 값을 가져온다
		list = empService.select_emp_list(sri);
		state = "true";
		// count를 이용한 페이징 처리를 한다.
		pageMaker.setCri(sri);
		int totalCnt = empService.selectTotalCnt(sri);
		pageMaker.setTotalCount(totalCnt);
		
		/* ====== VIEW에 전달 ====== */
		result.put("state", state);
		result.put("list", list);
		result.put("pageMaker", pageMaker);
		
		return result;
	}

	// 상세정보(인적사항, 학력정보, 경력정보)를 조회한다.
	@ResponseBody
	@RequestMapping(value = "/info.do", method=RequestMethod.POST)
	public HashMap<String, Object> info( EmpVO vo ) throws Exception {
		logger.info("인사 상세정보를 조회 START");
		/* ====== 변수 선언 ====== */
		HashMap<String, Object> result = new HashMap<>();	// 결과 반환할 해쉬맵
		EmpVO info = new EmpVO();	// 상세정보를 담을 객체
		ArrayList<EduVO> edu = new ArrayList();	// 학력정보 리스트를 담을 객체
		
		/* ====== DB 처리 ====== */
		info = empService.select_info(vo);  // 인적사항을 조회한다.
		edu = empService.select_edu(vo);  // 학력정보를 조회한다.
		 
		 /* ====== VIEW에 전달 ====== */
		result.put("info", info);
		result.put("edu", edu);
		
		return result;
	}
	
	// 인적사항 저장
	@ResponseBody
	@RequestMapping(value = "/save.do", method=RequestMethod.POST)
	public HashMap<String, Object> save( EmpVO vo ) throws Exception {
		logger.info("인적사항 저장 START");
		/* ====== 변수 선언 ====== */
		HashMap<String, Object> result = new HashMap<>();	// 결과 반환할 해쉬맵
		ArrayList<String> null_list = new ArrayList<>();		// null 체크 결과를 담을 리스트
		HashMap<String, Object> error_map = new HashMap<>();	// 유효성 체크 결과 메세지, 변수를 담을 해쉬맵
		ArrayList<HashMap<String,Object>> error_list = new ArrayList<>();	// 유효성 체크 결과 해쉬맵을 담을 리스트
		boolean check1 = true;	// 유효성 체크 결과를 담을 변수
		int check2;	// 유효성 체크 결과를 담을 변수
		boolean null_chk = true;	// 유효성 체크 결과를 담을 변수
		boolean error_check = true;	// 유효성이 검증여부 체크 변수, true 일 경우 DB에 저장
		
		
		/* ====== 데이터 수정 ====== */
		// 회사 이메일 아이디에 호스트값 추가
		if( EmpCheck.isNull(vo.getEmp_company_email()) == false ) {
			vo.setEmp_company_email( vo.getEmp_company_email()+"@company.co.kr" );
		}
		
		/* ====== 유효성 체크 ====== */		
		// VO null 체크
		ArrayList<String> vo_name = new ArrayList<>();  // null 체크하지 않을 변수
		vo_name.add("new_chk");
		vo_name.add("emp_period_chk");
		vo_name.add("emp_period_start");
		vo_name.add("emp_period_end");
		vo_name.add("emp_join_end");
		vo_name.add("emp_photo");
		// 신규 직원 체크 여부
		null_chk = EmpCheck.isNull(vo.getNew_chk());
		if( null_chk == false ) {
			vo_name.add("emp_no");
		}
		// vo에 null 이 있는지 체크하는 메서드, null이 있다면 해당 변수 리스트에 저장
		null_list = EmpCheck.findEmptyValue(vo, vo_name);
		if( null_list.isEmpty() == false ) {
			logger.info("인적사항 입력 null 값 존재 : " + null_list);
			error_check = false;
		}
		// 사원번호 체크 (숫자 여부)
		null_chk = EmpCheck.isNull(vo.getEmp_no());
		check1 = EmpCheck.isNull(vo.getNew_chk());
		if( null_chk == false && check1 != false ) {
			check1 = EgovNumberUtil.getNumberValidCheck(vo.getEmp_no());
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "숫자를 입력해주세요.");
				error_map.put("value", "emp_no");
				error_list.add(error_map);
				error_check = false;
			}
		}
		// 성명 체크 (한글 여부)
		null_chk = EmpCheck.isNull(vo.getEmp_name());
		if( null_chk == false ) {
			check1 = EmpCheck.isKorean(vo.getEmp_name());
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "한글을 입력해주세요.");
				error_map.put("value", "emp_name");
				error_list.add(error_map);
				error_check = false;
			}
		}
		// 주민번호 체크 (주민번호 여부)
		null_chk = EmpCheck.isNull(vo.getEmp_jumin());
		if( null_chk == false ) {
			check1  = EgovNumberCheckUtil.checkJuminNumber( EgovStringUtil.removeMinusChar(vo.getEmp_jumin()) );
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "주민번호를 확인해주세요.");
				error_map.put("value", "emp_jumin");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 생년월일 체크
		null_chk = EmpCheck.isNull(vo.getEmp_birth());
		if( null_chk == false ) {
			check1 = EgovDateUtil.checkDate( EgovStringUtil.removeMinusChar(vo.getEmp_birth()) );
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "생년월일을 확인해주세요.");
				error_map.put("value", "emp_birth");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 핸드폰 체크
		null_chk = EmpCheck.isNull(vo.getEmp_phone());
		if( null_chk == false ) {
			check1 = EgovFormatCheckUtil.checkFormatCell(vo.getEmp_phone() );
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "핸드폰 번호를 확인해주세요.");
				error_map.put("value", "emp_phone");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 회사전화 체크
		null_chk = EmpCheck.isNull(vo.getEmp_company_phone());
		if( null_chk == false ) {
			check1 = EgovFormatCheckUtil.checkFormatTell(vo.getEmp_company_phone() );
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "회사 전화번호를 확인해주세요.");
				error_map.put("value", "emp_company_phone");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 회사 이메일 체크
		null_chk = EmpCheck.isNull(vo.getEmp_company_email());
		if( null_chk == false ) {
			check1 = EgovFormatCheckUtil.checkFormatMail(vo.getEmp_company_email() );
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "회사 이메일을 확인해주세요.");
				error_map.put("value", "emp_company_email");
				error_list.add(error_map);
				error_check = false;
			}
		}
		// 외부 이메일 체크
		null_chk = EmpCheck.isNull(vo.getEmp_personal_email());
			if( null_chk == false ) {
			check1 = EgovFormatCheckUtil.checkFormatMail(vo.getEmp_personal_email() );
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "외부 이메일을 확인해주세요.");
				error_map.put("value", "emp_personal_email");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 우편번호 체크
		null_chk = EmpCheck.isNull(vo.getEmp_zip_code());
		if( null_chk == false ) {
			check1 = EmpCheck.isZip(vo.getEmp_zip_code() );
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "우편번호를 확인해주세요.");
				error_map.put("value", "emp_zip_code");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 주소2 (상세주소) 체크
		null_chk = EmpCheck.isNull(vo.getEmp_addr2());
		if( null_chk == false ) {
			// 주소1이 없으면 상세주소 false
			check1 = EmpCheck.isNull(vo.getEmp_addr1());
			if( check1 != false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "주소를 확인해주세요.");
				error_map.put("value", "emp_addr2");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 수습기간 시작날짜 체크
		null_chk = EmpCheck.isNull(vo.getEmp_period_start()) && EmpCheck.isNull(vo.getEmp_period_end());
		if( null_chk == false ) {
			check2 = EgovDateUtil.getDaysDiff( vo.getEmp_period_start(), vo.getEmp_period_end() );
			if( check2 < 0 ) {
				error_map = new HashMap<>();
				error_map.put("msg", "수습기간 일자를 확인해주세요..");
				error_map.put("value", "emp_period_start");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 수습기간 종료날짜 체크
		null_chk = EmpCheck.isNull(vo.getEmp_period_start()) && EmpCheck.isNull(vo.getEmp_period_end());
		if( null_chk == false ) {
			check2 = EgovDateUtil.getDaysDiff( vo.getEmp_period_start(), vo.getEmp_period_end() );
			if( check2 < 0 ) {
				error_map = new HashMap<>();
				error_map.put("msg", "수습기간 일자를 확인해주세요..");
				error_map.put("value", "emp_period_end");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 입사일자 체크
		null_chk = EmpCheck.isNull(vo.getEmp_join_start());
		if( null_chk == false ) {
			check1 = EgovDateUtil.checkDate( EgovStringUtil.removeMinusChar(vo.getEmp_join_start()));
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "입사일자를 확인해주세요..");
				error_map.put("value", "emp_join_start");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		// 퇴직일자 체크
		null_chk = EmpCheck.isNull(vo.getEmp_join_end());
		if( null_chk == false ) {
			check1 = EgovDateUtil.checkDate( EgovStringUtil.removeMinusChar(vo.getEmp_join_end()));
			if( check1 == false ) {
				error_map = new HashMap<>();
				error_map.put("msg", "퇴직일자를 확인해주세요..");
				error_map.put("value", "emp_join_end");
				error_list.add(error_map);
				error_check = false;
			} 
		}
		
		
		/* ====== DB에 저장 ====== */
		String state = "false";
		// 유효성 검사를 통과한 경우 DB에 연결
		if( error_check != false ) {
			// 신규 사원(1) 일 경우 insert, 아닐 경우 update
			if( vo.getNew_chk().equals("1") ) {
				empService.insertEmp(vo);
				state = "save";
			} 
			else {
//				empService.updateEmp(vo);
				state = "update";
			}
		} else {
			state = "false";
		}
		
		/* ====== 결과값 리턴 ====== */
		result.put("null_list", null_list);
		result.put("error_list", error_list);
		result.put("state", state);
			
		return result;
	}
	
	// 우편주소 팝업창
	@RequestMapping(value = "/post_road.do")
	public String main3(  ) throws Exception {
		return "emp/jusoPopup";
	}
	
	// 학력정보를 저장한다.
	@ResponseBody
	@RequestMapping(value="/edu_save.do", method = RequestMethod.POST, consumes="application/json")
	public HashMap<String, Object> edu_save( @RequestBody EduVO eduVO ) throws Exception {
		logger.info("학력정보 저장 실행");
		/* 데이터 매핑 테스트
		for(EduVO str : eduVO.getEdu_list()) {
			System.out.println("no---------->" + str.getEdu_no());
			System.out.println("name---------->" + str.getEdu_start());
		}
		System.out.println("emp_no---------->" + eduVO.getEmp_no());
		*/
		
		/* ========== 변수 선언 ========== */
		HashMap<String, Object> result = new HashMap<>();
		ArrayList<String> null_list = new ArrayList<>();		// null 체크 결과를 담을 리스트
		
		/* ====== 유효성 체크 ====== */		
		// VO null 체크
		ArrayList<String> vo_name = new ArrayList<>();  // null 체크할 변수
		vo_name.add("edu_start");
		vo_name.add("edu_end");
		vo_name.add("edu_school");
		// vo에 null 이 있는지 체크하는 메서드, null이 있다면 해당 변수 리스트에 저장
		null_list = EmpCheck.findEmptyValue2(eduVO, vo_name);
		if( null_list.isEmpty() == false ) {
			logger.info("인적사항 입력 null 값 존재 : " + null_list);
			result.put("state", "false");
			return result;
		}
		
		/* DB sevice */
		empService.insertEdu( eduVO );
		
		result.put("state", "true");
		
		return result;
	}
}
