<jsp:useBean id="student" class="com.demo.bean.StudentBean" />

<jsp:setProperty name="student" property="*" />

<html>
  <body>
    <h2>Student Profile</h2>

    Name: <jsp:getProperty name="student" property="name" /><br />
    Age: <jsp:getProperty name="student" property="age" />
  </body>
</html>