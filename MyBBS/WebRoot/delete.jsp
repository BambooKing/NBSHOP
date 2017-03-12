<%@ page pageEncoding="GB18030"%>
<%@ page import="java.sql.*, com.bjsxt.bbs.*, java.util.*"%>
<%@ include file = "_SessionCheck.jsp" %>
	<%!
	private void delete(Connection conn, int id, boolean isLeaf) {
	    //delete all the children
	    //delete (conn,chirds`s)
	   //delete self
	    if(!isLeaf){
	    
		String sql = "select * from article where pid = " + id;
		Statement stmt = DB.createStmt(conn);
		ResultSet rs = DB.executeQuery(stmt, sql); 
		try {
			while(rs.next()) {
			   delete(conn, rs.getInt("id"), rs.getInt("isLeaf") == 0);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			DB.close(rs);
			DB.close(stmt);
		}
	}
	DB.executeUpdate(conn,"delete from article where id =" + id );
	}
	%>
	
	
	
	<%
	int id = Integer.parseInt(request.getParameter("id"));
	int pid = Integer.parseInt(request.getParameter("pid"));
	boolean isLeaf = Boolean.parseBoolean(request.getParameter("isLeaf"));
	String url = request.getParameter("from");
	System.out.println("url="+url);
	Connection conn = null;
	Boolean autoCommit = true;
	Statement stmt = null;
	ResultSet rs =null;
	try{
	 conn = DB.getConn();
	 autoCommit = conn.getAutoCommit();
	conn.setAutoCommit(false);
	delete(conn, id, isLeaf);
	 stmt = DB.createStmt(conn);
	 rs = DB.executeQuery(stmt, "select count(*) from article where pid = " + pid);
	rs.next();
	int count = rs.getInt(1);
	if(count <= 0){
	   DB.executeUpdate(conn, "update article set isLeaf = 0 where id =" + pid);
	}
		conn.commit();
	}finally{
	conn.setAutoCommit(autoCommit);
	DB.close(rs);
	DB.close(stmt);
	DB.close(conn);
	}
	response.sendRedirect(url);
	%>
	Congratulations!
	<tr><%= id %>---<%=isLeaf %></tr>
	
