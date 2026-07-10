<%@ page import="java.sql.*" %>
<%@ page import="dal.DBContext" %>
<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%
    try {
        DBContext db = new DBContext();
        Connection conn = db.getConnection();
        if (conn == null) {
            out.println("Connection is NULL!");
        } else {
            out.println("Routes in table:");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT RouteID, RouteNumber, RouteName FROM Routes");
            while (rs.next()) {
                out.println("ID=" + rs.getInt("RouteID") + 
                            ", Number=" + rs.getString("RouteNumber") + 
                            ", Name=" + rs.getString("RouteName"));
            }
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
