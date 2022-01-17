package egovframework.hr.service;

public class Criteria {
	private int page;			// 현재 페이지 값
	private int perPageNum;	// 페이지당 보여지는 리스트 개수
	private int rowStart;		// 페이지별 rowStart 를 이용해 DB에서 페이징 처리를 한다
	private int rowEnd;			// 페이지별 rowEnd 를 이용해 DB에서 페이징 처리를 한다
	
	// perPageNum = 보여지는 게시판 개수
	public Criteria() {
		this.page = 1;
		this.perPageNum = 5;
	}
	
	public void setPage(int page) {
		if(page <= 0 ) {
			this.page  = 1;
			return;
		}
		this.page = page;
	}
	
	public void setPerPageNum(int perPageNum) {
		if(perPageNum <= 0 || perPageNum > 100) {	
			this.perPageNum = 10;
			return;
		}
		this.perPageNum = perPageNum;
	}

	public int getPage() {
		return page;
	}
	
	public int getPageStart() {
		return (this.page - 1) * perPageNum;
	}
	
	public int getPerPageNum() {
		return this.perPageNum;
	}
	
	// 페이지별 rowStart 값 구하기
	public int getRowStart() {
		rowStart = ((page - 1) * perPageNum) + 1;
		return rowStart;
	}
	
	// 페이지별 rowEnd 값 구하기
	public int getRowEnd() {
		rowEnd = rowStart + perPageNum - 1;
		return rowEnd;
	}
	
	public void setRowStart(int rowStart) {
		this.rowStart = rowStart;
	}

	public void setRowEnd(int rowEnd) {
		this.rowEnd = rowEnd;
	}	
	
}
