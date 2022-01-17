package egovframework.hr.service;

import java.lang.reflect.Field;
import java.util.ArrayList;

public class EmpCheck {
	
    /**
     *  VO객체 내부의 원하는 변수만 NULL 및 공백 체크 순회
     *  obj = vo, str = null 체크 안할 변수 이름
     *  @Param VO객체, 변수명 배열
     *  @Return NULL 일경우 변수이름 리스트 반환
     */
    public static ArrayList<String> findEmptyValue(Object obj, ArrayList<String> vo_name) throws Exception {
    	// vo안에 변수명을 리스트로 담는다
    	ArrayList<String> null_vo_list = new ArrayList<>();
    	outerfor:
        for (Field field : obj.getClass().getDeclaredFields()) {
            field.setAccessible(true);
            // 제외할 경우 리스트에 담지 않고 outerfor 반복문으로 돌아감
            /*	배열 반복문
            for(String input_vo_name : vo_name) {*/
            for(int i=0; i<vo_name.size(); i++ ) {
	            if (field.getName().equals(vo_name.get(i)) ) {
	            	continue outerfor;
	            }
        	}	
            // null 또는 공백일 경우 해당 변수이름 리스트에 저장
            if (field.get(obj) == null || field.get(obj).toString().trim().equals("")) {
            	null_vo_list.add(field.getName());
            }
        }
        return null_vo_list;
    }
    
    /**
     *  VO객체 내부의 원하는 변수만 NULL 및 공백 체크 순회
     *  obj = vo, str = null 체크 안할 변수 이름
     *  @Param VO객체, 변수명 배열
     *  @Return NULL 일경우 변수이름 리스트 반환
     */
    public static ArrayList<String> findEmptyValue2(Object obj, ArrayList<String> vo_name) throws Exception {
    	// vo안에 변수명을 리스트로 담는다
    	ArrayList<String> null_vo_list = new ArrayList<>();
    	
    	outerfor:
        for (Field field : obj.getClass().getDeclaredFields()) {
            field.setAccessible(true);

            for(int i=0; i<vo_name.size(); i++ ) {
	            if (!field.getName().equals(vo_name.get(i)) ) {
	            	continue outerfor;
	            }
        	}	
            
            // null 또는 공백일 경우 해당 변수이름 리스트에 저장
            if (field.get(obj) == null || field.get(obj).toString().trim().equals("")) {
            	null_vo_list.add(field.getName());
            }
        }
        return null_vo_list;
    }
	
	/** 한글 체크 메서드 */
	public static boolean isKorean(String str) {
		return str.matches("^[가-힣]*$");
	}
	
	/** 우편번호 체크 메서드 */
	public static boolean isZip(String str) {
		return str.matches("^\\d{5}$"); 
	}
	
	/** 도로명 주소 체크 메서드 */
	public static boolean isAddr1(String str) {
		return str.matches("^[가-힣A-Za-z·\\d~\\-\\.]+(로|길)$"); 
	}
	
	/** NULL 체크	*/
	public static boolean isNull(String str) {
		return str == null || str.trim().isEmpty();
	}
}
