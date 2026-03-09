<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String num1Str = request.getParameter("num1");
    String num2Str = request.getParameter("num2");
    String op      = request.getParameter("op");
    String result  = "";
    String error   = "";

    if (num1Str != null && num2Str != null && op != null) {
        try {
            double n1 = Double.parseDouble(num1Str);
            double n2 = Double.parseDouble(num2Str);
            double res = 0;

            switch (op) {
                case "+": res = n1 + n2; break;
                case "-": res = n1 - n2; break;
                case "*": res = n1 * n2; break;
                case "/":
                    if (n2 == 0) { error = "Cannot divide by zero."; break; }
                    res = n1 / n2; break;
                case "%": res = n1 % n2; break;
                default: error = "Invalid operator.";
            }

            if (error.isEmpty()) {
                if (res == (long) res)
                    result = String.valueOf((long) res);
                else
                    result = String.valueOf(res);
            }

        } catch (NumberFormatException e) {
            error = "Please enter valid numbers.";
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculator</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #fafafa;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        /* ── Top bar (Instagram-style) ── */
        .topbar {
            position: fixed;
            top: 0; left: 0; right: 0;
            height: 54px;
            background: white;
            border-bottom: 1px solid #dbdbdb;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 100;
        }
        .topbar-logo {
            font-size: 1.3rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            color: #262626;
        }

        /* ── Card ── */
        .card {
            background: white;
            border: 1px solid #dbdbdb;
            border-radius: 4px;
            width: 100%;
            max-width: 500px;
            padding: 32px 28px 24px;
            margin-top: 20px;
        }

        /* ── Brand header inside card ── */
        .brand {
            text-align: center;
            margin-bottom: 24px;
        }
        .brand h2 {
            font-size: 1rem;
            font-weight: 600;
            color: #262626;
            letter-spacing: 0.2px;
        }
        .brand p {
            font-size: 0.78rem;
            color: #8e8e8e;
            margin-top: 3px;
        }

        /* ── Display ── */
        .display {
            background: #fafafa;
            border: 1px solid #dbdbdb;
            border-radius: 4px;
            padding: 14px 16px;
            margin-bottom: 16px;
            min-height: 72px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: flex-end;
        }
        .expr {
            font-size: 0.75rem;
            color: #8e8e8e;
            margin-bottom: 4px;
            min-height: 16px;
            font-weight: 400;
        }
        .result-val {
            font-size: 1.8rem;
            font-weight: 600;
            color: #262626;
            word-break: break-all;
        }
        .result-val.error-msg {
            font-size: 0.85rem;
            color: #ed4956;
            font-weight: 500;
        }

        /* ── Inputs ── */
        .inputs {
            display: flex;
            gap: 8px;
            margin-bottom: 10px;
        }
        .inputs input {
            flex: 1;
            padding: 9px 12px;
            border: 1px solid #dbdbdb;
            border-radius: 4px;
            font-size: 0.9rem;
            font-family: inherit;
            background: #fafafa;
            color: #262626;
            text-align: center;
            outline: none;
            transition: border-color 0.15s;
            -moz-appearance: textfield;
        }
        .inputs input::-webkit-outer-spin-button,
        .inputs input::-webkit-inner-spin-button { -webkit-appearance: none; }
        .inputs input::placeholder { color: #c7c7c7; font-size: 0.82rem; }
        .inputs input:focus { border-color: #a8a8a8; background: white; }

        /* ── Operator grid ── */
        .ops {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 6px;
            margin-bottom: 10px;
        }
        .op-btn {
            padding: 10px 0;
            border: 1px solid #dbdbdb;
            border-radius: 4px;
            background: white;
            font-size: 1rem;
            font-weight: 500;
            color: #262626;
            cursor: pointer;
            font-family: inherit;
            transition: background 0.12s, border-color 0.12s, color 0.12s;
        }
        .op-btn:hover {
            background: #fafafa;
            border-color: #a8a8a8;
        }
        .op-btn.active {
            background: #262626;
            border-color: #262626;
            color: white;
        }

        /* ── Calculate button ── */
        .btn-calc {
            width: 100%;
            padding: 11px;
            background: #0095f6;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 0.9rem;
            font-weight: 600;
            font-family: inherit;
            cursor: pointer;
            margin-bottom: 8px;
            transition: opacity 0.15s;
            letter-spacing: 0.2px;
        }
        .btn-calc:hover { opacity: 0.88; }

        /* ── Reset ── */
        .btn-reset {
            width: 100%;
            padding: 10px;
            background: none;
            border: 1px solid #dbdbdb;
            border-radius: 4px;
            color: #8e8e8e;
            font-size: 0.85rem;
            font-weight: 500;
            font-family: inherit;
            cursor: pointer;
            transition: border-color 0.15s, color 0.15s;
        }
        .btn-reset:hover { border-color: #a8a8a8; color: #262626; }

        /* ── Divider ── */
        .divider {
            display: flex;
            align-items: center;
            gap: 14px;
            margin: 14px 0;
        }
        .divider hr { flex: 1; border: none; border-top: 1px solid #dbdbdb; }
        .divider span { font-size: 0.72rem; font-weight: 600; color: #8e8e8e; letter-spacing: 1px; }

        /* ── Second card (sign up style) ── */
        .card2 {
            background: white;
            border: 1px solid #dbdbdb;
            border-radius: 4px;
            width: 100%;
            max-width: 360px;
            padding: 18px;
            text-align: center;
            margin-top: 10px;
            font-size: 0.85rem;
            color: #262626;
        }
        .card2 span { color: #8e8e8e; }
        .card2 strong { color: #0095f6; font-weight: 600; cursor: pointer; }

        /* ── Footer ── */
        footer {
            margin-top: 28px;
            font-size: 0.72rem;
            color: #c7c7c7;
            text-align: center;
        }
        footer a { color: #c7c7c7; text-decoration: none; margin: 0 6px; }
        footer a:hover { text-decoration: underline; }
    </style>
</head>
<body>



<!-- Main card -->
<div class="card">

    <div class="brand">
        <h2>Simple Calculator</h2>
        <p>Enter two numbers and pick an operator</p>
    </div>

    <!-- Display -->
    <div class="display">
        <div class="expr">
            <% if (num1Str != null && op != null && num2Str != null && !num1Str.isEmpty()) { %>
                <%= num1Str %> &nbsp;<%= op %>&nbsp; <%= num2Str %> =
            <% } else { %>
                &nbsp;
            <% } %>
        </div>
        <div class="result-val <%= !error.isEmpty() ? "error-msg" : "" %>">
            <% if (!error.isEmpty()) { %>
                <%= error %>
            <% } else if (!result.isEmpty()) { %>
                <%= result %>
            <% } else { %>
                0
            <% } %>
        </div>
    </div>

    <!-- Form -->
    <form method="post" action="calculator.jsp">

        <div class="inputs">
            <input type="number" name="num1" placeholder="First number" step="any"
                   value="<%= num1Str != null ? num1Str : "" %>" required />
            <input type="number" name="num2" placeholder="Second number" step="any"
                   value="<%= num2Str != null ? num2Str : "" %>" required />
        </div>

        <div class="ops">
            <% String[] operators = {"+", "-", "*", "/", "%"};
               for (String o : operators) { %>
            <button type="submit" name="op" value="<%= o %>"
                    class="op-btn <%= o.equals(op) ? "active" : "" %>">
                <%= o %>
            </button>
            <% } %>
        </div>

        <div class="divider">
            <hr/><span>OR</span><hr/>
        </div>

        <button type="submit" name="op" value="<%= op != null ? op : "+" %>" class="btn-calc">
            Calculate
        </button>

    </form>

    <form method="get" action="calculator.jsp">
        <button type="submit" class="btn-reset">Reset</button>
    </form>

</div>



</body>
</html>