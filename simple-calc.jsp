<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <title>Simple Calculator</title>
    </head>

    <body>
        <h1>Simple Calculator</h1>

        <form method="POST">
            <label>First Number:</label>
            <input type="number" name="num1" step="any" required>
            <br /><br />

            <label>Operator:</label>
            <select name="operator" required>
                <option value="">Select Operator</option>
                <option value="+">+ (Addition)</option>
                <option value="-">- (Subtraction)</option>
                <option value="*">* (Multiplication)</option>
                <option value="/">/ (Division)</option>
                <option value="%">% (Modulo)</option>
            </select>
            <br /><br />

            <label>Second Number:</label>
            <input type="number" name="num2" step="any" required>
            <br /><br />

            <button type="submit">Calculate</button>
        </form>

       <%
        String num1Str = request.getParameter("num1");
        String num2Str = request.getParameter("num2");
        String operator = request.getParameter("operator");

        if(num1Str != null && num2Str != null && operator != null){

            try{
                double num1 = Double.parseDouble(num1Str);
                double num2 = Double.parseDouble(num2Str);
                double result = 0;

                if(operator.equals("+")){
                    result = num1 + num2;
                }
                else if(operator.equals("-")){
                    result = num1 - num2;
                }
                else if(operator.equals("*")){
                    result = num1 * num2;
                }
                else if(operator.equals("/")){
                    if(num2 == 0){
                        out.println("Cannot divide by zero");
                    }else{
                        result = num1 / num2;
                    }
                }

                out.println("Result: " + result);

            }catch(Exception e){
                out.println("Invalid input");
            }

        }
        %>
    </body>

    </html>