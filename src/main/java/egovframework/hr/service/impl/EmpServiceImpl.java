package egovframework.hr.service.impl;

import java.util.ArrayList;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import egovframework.hr.service.EduVO;
import egovframework.hr.service.EmpCodeVO;
import egovframework.hr.service.EmpService;
import egovframework.hr.service.EmpVO;
import egovframework.hr.service.SearchCriteria;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("empService")
public class EmpServiceImpl extends EgovAbstractServiceImpl implements EmpService {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
		
	/** EmpMapper */
	@Resource(name = "empMapper")
	private EmpMapper empMapper;

	// 기본정보 리스트를 조회한다.
	@Override
	public ArrayList<EmpVO> select_emp_list(SearchCriteria sri) throws Exception {
		return empMapper.select_emp_list(sri);
	}
	// 기본정보 총 개수를 조회한다.
	@Override
	public int selectTotalCnt(SearchCriteria sri) throws Exception {
		return empMapper.selectTotalCnt(sri);
	}

	// 상세정보를 조회한다.
	@Override
	public EmpVO select_info(EmpVO vo) throws Exception {
		return empMapper.select_info(vo);
	}
	
	// 인적사항을 등록한다.
	@Override
	public void insertEmp(EmpVO vo) throws Exception {
		logger.info("ServiceImpl insertEmp");
		empMapper.insertEmp(vo);
	}
	
	// 학력정보를 조회한다.
	@Override
	public ArrayList<EduVO> select_edu(EmpVO vo) throws Exception {
		return empMapper.select_edu(vo);
	}
	// 학력정보를 입력, 수정, 삭제한다.
	@Override
	public void insertEdu(EduVO eduVO) throws Exception {
		empMapper.deleteEdu(eduVO);
		empMapper.updateEdu(eduVO);
	}

	/* === 코드 리스트 ==== */
	// 직급 코드 리스트
	@Override
	public ArrayList<EmpCodeVO> select_emp_rank() throws Exception {
		return empMapper.select_emp_rank();
	}
	// 직책 코드 리스트
	@Override
	public ArrayList<EmpCodeVO> select_emp_position() throws Exception {
		return empMapper.select_emp_position();
	}
	// 계약기준 코드 리스트
	@Override
	public ArrayList<EmpCodeVO> select_emp_contract() throws Exception {
		return empMapper.select_emp_contract();
	}
	// 재직구분 코드 리스트
	@Override
	public ArrayList<EmpCodeVO> select_emp_work() throws Exception {
		return empMapper.select_emp_work();
	}

}
