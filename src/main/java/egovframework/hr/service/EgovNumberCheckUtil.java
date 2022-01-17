package egovframework.hr.service;

/**
 *
 * 번호유효성체크 에 대한 Util 클래스
 * @author 공통컴포넌트 개발팀 윤성록
 * @since 2009.06.10
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.06.10  윤성록          최초 생성
 *   2012.02.27  이기하          법인번호 체크로직 수정
 *
 * </pre>
 */
public class EgovNumberCheckUtil {

	 /**
     * <p>XXXXXX - XXXXXXX 형식의 주민번호 앞, 뒤 문자열 2개 입력 받아 유효한 주민번호인지 검사.</p>
     *
     *
     * @param   6자리 주민앞번호 문자열 , 7자리 주민뒷번호 문자열
     * @return  유효한 주민번호인지 여부 (True/False)
     */
    @SuppressWarnings("static-access")
	public static boolean checkJuminNumber(String jumin1, String jumin2) {

    	EgovDateUtil egovDateUtil = new EgovDateUtil();
    	String juminNumber = jumin1 + jumin2;
    	String  IDAdd = "234567892345"; 	// 주민등록번호에 가산할 값

		int count_num = 0;
    	int add_num = 0;
        int total_id = 0;      //검증을 위한 변수선언
        if (juminNumber.length() != 13) return false;	 // 주민등록번호 자리수가 맞는가를 확인
       	for (int i = 0; i <12 ; i++){
       		if(juminNumber.charAt(i)< '0' || juminNumber.charAt(i) > '9') return false;		//숫자가 아닌 값이 들어왔는지를 확인
       		count_num = Character.getNumericValue(juminNumber.charAt(i));
       		add_num = Character.getNumericValue(IDAdd.charAt(i));
        	total_id += count_num * add_num;      //유효자리 검증식을 적용
        }
       	if(Character.getNumericValue(juminNumber.charAt(0)) == 0 || Character.getNumericValue(juminNumber.charAt(0)) == 1){
       		if(Character.getNumericValue(juminNumber.charAt(6)) > 4) return false;
       		String temp = "20" + juminNumber.substring(0,6);
       		if(!egovDateUtil.checkDate(temp)) return false;
       	}else{
       		if(Character.getNumericValue(juminNumber.charAt(6)) > 2) return false;
       		String temp = "19" + juminNumber.substring(0,6);
       		if(!egovDateUtil.checkDate(temp)) return false;
       	}	//주민번호 앞자리 날짜유효성체크 & 성별구분 숫자 체크
       	return true;
       	/*
       	if(Character.getNumericValue(juminNumber.charAt(12)) == (11 - (total_id % 11)) % 10) //마지막 유효숫자와 검증식을 통한 값의 비교
        	return true;
        else
        	return false;*/
    }

    /**
     * <p>XXXXXXXXXXXXX 형식의 13자리 주민번호 1개를 입력 받아 유효한 주민번호인지 검사.</p>
     *
     *
     * @param   13자리 주민번호 문자열
     * @return  유효한 주민번호인지 여부 (True/False)
     */
    public static boolean checkJuminNumber(String jumin) {

    	if(jumin.length() != 13) return false;

        return checkJuminNumber(jumin.substring(0,6), jumin.substring(6,13));	//주민번호
    }

  
}


