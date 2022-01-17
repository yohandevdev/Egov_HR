package egovframework.hr.service;

import java.util.ArrayList;

public interface EmpService {

	// 기본정보 리스트를 조회한다.
	ArrayList<EmpVO> select_emp_list(SearchCriteria sri) throws Exception;
	// 기본정보 총 개수를 조회한다.
	int selectTotalCnt(SearchCriteria sri) throws Exception;

	// 상세정보를 조회한다.
	EmpVO select_info(EmpVO vo) throws Exception;
	
	// 인적사항을 등록한다.
	void insertEmp(EmpVO vo) throws Exception;
	
	// 학력정보를 조회한다.
	ArrayList<EduVO> select_edu(EmpVO vo) throws Exception;
	// 학력정보를 입력, 수정, 삭제한다.
	void insertEdu(EduVO eduVO) throws Exception;

	// 직급 코드 리스트
	ArrayList<EmpCodeVO> select_emp_rank() throws Exception;
	// 직책 코드 리스트
	ArrayList<EmpCodeVO> select_emp_position() throws Exception;
	// 계약기준 코드 리스트
	ArrayList<EmpCodeVO> select_emp_contract() throws Exception;
	// 재직구분 코드 리스트
	ArrayList<EmpCodeVO> select_emp_work() throws Exception;
	

}
