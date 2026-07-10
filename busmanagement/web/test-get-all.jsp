<%@ page import="service.NotificationService" %>
<%@ page import="model.Notification" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/plain;charset=UTF-8" language="java" %>
<%
    try {
        NotificationService ns = new NotificationService();
        List<Notification> list = ns.getAllNotifications();
        out.println("List size from NotificationService: " + (list == null ? "NULL" : list.size()));
        if (list != null) {
            for (Notification n : list) {
                out.println("ID: " + n.getNotificationID() + ", Type: " + n.getNotificationType() + ", Title: " + n.getTitle());
            }
        }
    } catch (Exception e) {
        out.println("Exception: " + e.getMessage());
        e.printStackTrace(new java.io.PrintWriter(out));
    }
%>
