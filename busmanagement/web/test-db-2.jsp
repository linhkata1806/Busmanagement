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
            out.println("Connection is successful!");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM Notifications");
            if (rs.next()) {
                out.println("Total notifications in table: " + rs.getInt(1));
            }
            ResultSet rsRows = stmt.executeQuery("SELECT * FROM Notifications");
            while (rsRows.next()) {
                out.println("ROW: ID=" + rsRows.getInt("NotificationID") + 
                            ", AccountID=" + rsRows.getInt("AccountID") + " (Null: " + rsRows.wasNull() + ")" +
                            ", Type=" + rsRows.getString("NotificationType") + 
                            ", Title=" + rsRows.getString("Title") + 
                            ", Content=" + rsRows.getString("Content") + 
                            ", CreatedAt=" + rsRows.getTimestamp("CreatedAt"));
            }
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
