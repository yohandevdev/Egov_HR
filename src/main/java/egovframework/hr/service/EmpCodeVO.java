package egovframework.hr.service;

public class EmpCodeVO {
	private String emp_rank_code;
	private String emp_rank_name;
	private String emp_position_code;
	private String emp_position_name;
	private String emp_contract_code;
	private String emp_contract_name;
	private String emp_work_code;
	private String emp_work_name;
	
	public String getEmp_rank_code() {
		return emp_rank_code;
	}
	public void setEmp_rank_code(String emp_rank_code) {
		this.emp_rank_code = emp_rank_code;
	}
	public String getEmp_rank_name() {
		return emp_rank_name;
	}
	public void setEmp_rank_name(String emp_rank_name) {
		this.emp_rank_name = emp_rank_name;
	}
	public String getEmp_position_code() {
		return emp_position_code;
	}
	public void setEmp_position_code(String emp_position_code) {
		this.emp_position_code = emp_position_code;
	}
	public String getEmp_position_name() {
		return emp_position_name;
	}
	public void setEmp_position_name(String emp_position_name) {
		this.emp_position_name = emp_position_name;
	}
	public String getEmp_contract_code() {
		return emp_contract_code;
	}
	public void setEmp_contract_code(String emp_contract_code) {
		this.emp_contract_code = emp_contract_code;
	}
	public String getEmp_contract_name() {
		return emp_contract_name;
	}
	public void setEmp_contract_name(String emp_contract_name) {
		this.emp_contract_name = emp_contract_name;
	}
	public String getEmp_work_code() {
		return emp_work_code;
	}
	public void setEmp_work_code(String emp_work_code) {
		this.emp_work_code = emp_work_code;
	}
	public String getEmp_work_name() {
		return emp_work_name;
	}
	public void setEmp_work_name(String emp_work_name) {
		this.emp_work_name = emp_work_name;
	}
	
	@Override
	public String toString() {
		return "EmpCodeVO [emp_rank_code=" + emp_rank_code + ", emp_rank_name=" + emp_rank_name + ", emp_position_code="
				+ emp_position_code + ", emp_position_name=" + emp_position_name + ", emp_contract_code="
				+ emp_contract_code + ", emp_contract_name=" + emp_contract_name + ", emp_work_code=" + emp_work_code
				+ ", emp_work_name=" + emp_work_name + ", getEmp_rank_code()=" + getEmp_rank_code()
				+ ", getEmp_rank_name()=" + getEmp_rank_name() + ", getEmp_position_code()=" + getEmp_position_code()
				+ ", getEmp_position_name()=" + getEmp_position_name() + ", getEmp_contract_code()="
				+ getEmp_contract_code() + ", getEmp_contract_name()=" + getEmp_contract_name()
				+ ", getEmp_work_code()=" + getEmp_work_code() + ", getEmp_work_name()=" + getEmp_work_name()
				+ ", getClass()=" + getClass() + ", hashCode()=" + hashCode() + ", toString()=" + super.toString()
				+ "]";
	}
}
