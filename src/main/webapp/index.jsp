<%@ page import="ecs189.querying.github.GithubQuerier" %><%--
  Created by IntelliJ IDEA.
  User: Vincent
  Date: 7/3/2017
  Time: 8:47 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <meta name="viewport" content="initial-scale=1, maximum-scale=1">
    <link rel='stylesheet' href='webjars/bootstrap/3.2.0/css/bootstrap.min.css'>
    <link rel='stylesheet' href='main.css'>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <title>Github Stalker</title>
  </head>
  <body>
  <div id="core">
    <h2>What Have I Been Up To?</h2>
    <form action="index.jsp" method="GET">
      <div class="form-group">
        <label for="user"><h3>Github username:</h3></label>
        <input type="user" name="user_name" class="form-control" id="user"
               value="<%= request.getParameter("user_name") == null ? "" : request.getParameter("user_name")%>">
      </div>
      <%String user=request.getParameter("user_name"); %>
      <button type="submit" class="btn btn-primary">
        <c:choose>
          <c:when test="${empty user}">
            Submit
          </c:when>
          <c:otherwise>
            Refresh
          </c:otherwise>
        </c:choose>
      </button>
    </form>
    <div id="activity">
      <%if (user != null && !user.isEmpty()){%>
          <%=GithubQuerier.eventsAsHTML(user)%>
        <% } else { %>
            Tell me who you are, and I will tell you what you did last ... week? Month? Summer? Not sure yet.
        <% }%>
    </div>
  </div>

  <!-- YOUR CODE HERE -->
  <script type="text/javascript" src="webjars/jquery/2.1.1/jquery.min.js"></script>
  <script type="text/javascript" src="webjars/bootstrap/3.2.0/js/bootstrap.min.js"></script>
  </body>
</html>
