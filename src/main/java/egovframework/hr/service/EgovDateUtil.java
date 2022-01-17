package egovframework.hr.service;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

/**
 *
 * Date 에 대한 Util 클래스
 * @author 공통서비스 개발팀 이중호
 * @since 2009.02.01
 * @version 1.0
 * @see
 *
 * <pre>
 * << 개정이력(Modification Information) >>
 *
 *   수정일      수정자           수정내용
 *  -------    --------    ---------------------------
 *   2009.02.01  이중호          최초 생성
 *
 * </pre>
 */
public class EgovDateUtil {
	/**
	 * <p>yyyyMMdd 혹은 yyyy-MM-dd 형식의 날짜 문자열을 입력 받아 유효한 날짜인지 검사.</p>
	 *
	 * <pre>
	 * DateUtil.checkDate("1999-02-35") = false
	 * DateUtil.checkDate("2000-13-31") = false
	 * DateUtil.checkDate("2006-11-31") = false
	 * DateUtil.checkDate("2006-2-28")  = false
	 * DateUtil.checkDate("2006-2-8")   = false
	 * DateUtil.checkDate("20060228")   = true
	 * DateUtil.checkDate("2006-02-28") = true
	 * </pre>
	 *
	 * @param  dateStr 날짜 문자열(yyyyMMdd, yyyy-MM-dd의 형식)
	 * @return  유효한 날짜인지 여부
	 */
	public static boolean checkDate(String sDate) {
		String dateStr = validChkDate(sDate);
		if( dateStr.equals("bad") ) {
			return false;
		}

		String year = dateStr.substring(0, 4);
		String month = dateStr.substring(4, 6);
		String day = dateStr.substring(6);

		return checkDate(year, month, day);
	}
	
	/**
	 * <p>입력한 년, 월, 일이 유효한지 검사.</p>
	 *
	 * @param  year 연도
	 * @param  month 월
	 * @param  day 일
	 * @return  유효한 날짜인지 여부
	 */
	public static boolean checkDate(String year, String month, String day) {
		try {
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy.MM.dd", Locale.getDefault());

			Date result = formatter.parse(year + "." + month + "." + day);
			String resultStr = formatter.format(result);
			if (resultStr.equalsIgnoreCase(year + "." + month + "." + day))
				return true;
			else
				return false;
		} catch (ParseException e) {
			return false;
		}
	}
	
	/**
	 * 입력된 일자 문자열을 확인하고 8자리로 리턴
	 * @param sDate
	 * @return
	 */
	public static String validChkDate(String dateStr) {
		if (dateStr == null || !(dateStr.trim().length() == 8 || dateStr.trim().length() == 10)) {
			return "bad";
		}
				
		if (dateStr.length() == 10) {
			return EgovStringUtil.removeMinusChar(dateStr);
		}
		
		return dateStr;
	}
	
	
	/**
	 * <p>yyyyMMdd 혹은 yyyy-MM-dd 형식의 날짜 문자열 <code>dateStr1</code>과 <code>
	 * dateStr2</code> 사이의 일 수를 구한다.<br>
	 * <code>dateStr2</code>가 <code>dateStr1</code> 보다 과거 날짜일 경우에는
	 * 음수를 반환한다. 동일한 경우에는 0을 반환한다.</p>
	 *
	 * <pre>
	 * DateUtil.getDaysDiff("20060228","20060310") = 10
	 * DateUtil.getDaysDiff("20060101","20070101") = 365
	 * DateUtil.getDaysDiff("19990228","19990131") = -28
	 * DateUtil.getDaysDiff("20060801","20060802") = 1
	 * DateUtil.getDaysDiff("20060801","20060801") = 0
	 * </pre>
	 *
	 * @param  dateStr1 날짜 문자열(yyyyMMdd, yyyy-MM-dd의 형식)
	 * @param  dateStr2 날짜 문자열(yyyyMMdd, yyyy-MM-dd의 형식)
	 * @return  일 수 차이.
	 * @throws IllegalArgumentException 날짜 포맷이 정해진 바와 다를 경우.
	 *         입력 값이 <code>null</code>인 경우.
	 */
	public static int getDaysDiff(String sDate1, String sDate2) {
		String dateStr1 = validChkDate(sDate1);
		String dateStr2 = validChkDate(sDate2);

		if (!checkDate(sDate1) || !checkDate(sDate2)) {
			throw new IllegalArgumentException("Invalid date format: args[0]=" + sDate1 + " args[1]=" + sDate2);
		}
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd", Locale.getDefault());

		Date date1 = null;
		Date date2 = null;
		try {
			date1 = sdf.parse(dateStr1);
			date2 = sdf.parse(dateStr2);
		} catch (ParseException e) {
			throw new IllegalArgumentException("Invalid date format: args[0]=" + dateStr1 + " args[1]=" + dateStr2);
		}

		if (date1 != null && date2 != null) {
			int days1 = (int) ((date1.getTime() / 3600000) / 24);
			int days2 = (int) ((date2.getTime() / 3600000) / 24);
			return days2 - days1;
		} else {
			return 0;
		}

	}

}
