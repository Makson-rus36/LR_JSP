<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.net.InetAddress" %>
<%@ page import="java.util.Date" %><%--
  Created by IntelliJ IDEA.
  User: Maks
  Date: 03.11.2020
  Time: 12:25
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<%

    if(request.getParameter("password")=="" || request.getParameter("login")==""){
        out.println("<form action=\"index.jsp\" method=\"POST\"" +
                "<h1>Введите логин или пароль</h1><br><br>" +
                "<input type=\"submit\" value=\"Retry\" />");
}else {
        try {
            Connection connection=null;

            Class.forName("com.mysql.jdbc.Driver");
            //connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/lrservlet?verifyServerCertificate=false&useSSL=false&requireSSL=false&useLegacyDatetimeCode=false&amp&serverTimezone=UTC");
            connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/lrservlet?verifyServerCertificate=false&useSSL=false&requireSSL=false&useLegacyDatetimeCode=false&amp&serverTimezone=UTC","root","root");
            Statement stat = connection.createStatement();

            ResultSet rs = stat.executeQuery("select id,_name,_lastname " +
                    "from users " +
                    "where _id_login = (select id from paswordss where logins='"+request.getParameter("login")+ "' and passwords='"+request.getParameter("password")+"');");
            if(rs.next()){
                Statement stat1 = connection.createStatement();
                Statement stat2 = connection.createStatement();
                Statement stat3 = connection.createStatement();
                java.util.Date date = new Date();
                Object param = new java.sql.Timestamp(date.getTime());
                String sql_adr_ip_ins =  "insert into journal(id_user,ip_user, _time) values("+rs.getString("id")+",'"+InetAddress.getLocalHost().getHostAddress()+"','"+param+"')";
                stat1.execute(sql_adr_ip_ins);
                out.println("<!DOCTYPE html>");
                out.println("<html>");
                out.println("<head>");
                out.println("<title>Добро пожаловать</title>");
                out.println("</head>");
                out.println("<body>");
                out.println("<h2>Привет, "+rs.getString("_name")+" "+rs.getString("_lastname")+"!!!</h1>");
                ResultSet rs2 = stat2.executeQuery("select count(id_user) as counts from journal where id_user = "+rs.getString("id"));
                if(rs2.next());
                out.println("<h3>Вы заходили (раз): "+rs2.getString("counts"));
                out.println("<h3>Журнал ваших посещений: </h3>");
                ResultSet rs3 = stat3.executeQuery("select ip_user, _time from journal where id_user = "+rs.getString("id"));
                out.println("<table>");
                while (rs3.next())
                {
                    out.println("<tr>");
                    out.println("<td>IP: "+rs3.getString("ip_user")+"<td>");
                    out.println("<td>Time: "+rs3.getString("_time")+"<td>");
                    out.println("</tr>");
                }
                out.println("</table>");
                out.println("</body>");
                out.println("</html>");}
            else {
                out.println("<!DOCTYPE html>");
                out.println("<html>");
                out.println("<head>");
                out.println("<title>Ошибка входа</title>");
                out.println("</head>");
                out.println("<body>");
                out.println("<form action=\"index.jsp\" method=\"POST\"" +
                        "<h1>Логин или пароль неверный</h1><br><br>" +
                        "<input type=\"submit\" value=\"На страницу входа\" />");
                out.println("</body>");
                out.println("</html>");
            }
        }catch (Exception e){
            out.println(e.getMessage());
        }
}
%>
</body>
</html>
