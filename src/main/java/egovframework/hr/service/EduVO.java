package egovframework.hr.service;

import java.util.ArrayList;
import java.util.List;

public class EduVO {
	private String edu_no;
	private String edu_start;
	private String edu_end;
	private String edu_school;
	private String edu_major;
	private String edu_degree;
	private String edu_status;
	private String emp_no;
	
	private List<EduVO> edu_list;
	
	
	public List<EduVO> getEdu_list() {
		return edu_list;
	}
	public void setEdu_list(List<EduVO> edu_list) {
		this.edu_list = edu_list;
	}
	public String getEmp_no() {
		return emp_no;
	}
	public void setEmp_no(String emp_no) {
		this.emp_no = emp_no;
	}
	public String getEdu_no() {
		return edu_no;
	}
	public void setEdu_no(String edu_no) {
		this.edu_no = edu_no;
	}
	public String getEdu_start() {
		return edu_start;
	}
	public void setEdu_start(String edu_start) {
		this.edu_start = edu_start;
	}
	public String getEdu_end() {
		return edu_end;
	}
	public void setEdu_end(String edu_end) {
		this.edu_end = edu_end;
	}
	public String getEdu_school() {
		return edu_school;
	}
	public void setEdu_school(String edu_school) {
		this.edu_school = edu_school;
	}
	public String getEdu_major() {
		return edu_major;
	}
	public void setEdu_major(String edu_major) {
		this.edu_major = edu_major;
	}
	public String getEdu_degree() {
		return edu_degree;
	}
	public void setEdu_degree(String edu_degree) {
		this.edu_degree = edu_degree;
	}
	public String getEdu_status() {
		return edu_status;
	}
	public void setEdu_status(String edu_status) {
		this.edu_status = edu_status;
	}
	
}
