package p1;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
import java.sql.*;
import java.util.Calendar;
import java.util.Base64;
import java.nio.charset.StandardCharsets;

import javax.crypto.Cipher;
import javax.crypto.spec.SecretKeySpec;

import p1.dbcon;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author takkr
 */
@WebServlet(urlPatterns = {"/Register"})
public class Register extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
private static final String AES_KEY="1234567890abcdef";

public String encryptAES(String data)throws Exception{

    SecretKeySpec key =
        new SecretKeySpec(AES_KEY.getBytes(StandardCharsets.UTF_8),"AES");

    Cipher cipher=Cipher.getInstance("AES");

    cipher.init(Cipher.ENCRYPT_MODE,key);

    return Base64.getEncoder().encodeToString(
            cipher.doFinal(data.getBytes(StandardCharsets.UTF_8)));
}

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
           




        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request , HttpServletResponse response)
            throws ServletException, IOException{
        String msg="";

if(request.getParameter("register")!=null){

String name=request.getParameter("name");
String gender=request.getParameter("gender");
String dob=request.getParameter("dob");
String age=request.getParameter("age");
String mobile=request.getParameter("mobile");
String email=request.getParameter("email");
String password=request.getParameter("password");
String address=request.getParameter("address");
String height=request.getParameter("height");
String weight=request.getParameter("weight");
String plan=request.getParameter("plan");

try{

Connection con=new dbcon().getConnection();


// Duplicate Email Check

PreparedStatement check=
con.prepareStatement("select * from members where email=?");

check.setString(1,email);

ResultSet rs=check.executeQuery();

if(rs.next()){

msg="Email already registered.";

}else{

// Encrypt Password

String encPassword=encryptAES(password);


// Join Date

java.sql.Date joinDate=
new java.sql.Date(System.currentTimeMillis());


// Expiry Date

Calendar c=Calendar.getInstance();

if(plan.equals("1")){

c.add(Calendar.MONTH,1);

}

else if(plan.equals("2")){

c.add(Calendar.MONTH,3);

}

else{

c.add(Calendar.YEAR,1);

}

java.sql.Date expiryDate=
new java.sql.Date(c.getTimeInMillis());


// Insert Member

PreparedStatement ps=

con.prepareStatement(

"insert into members(name,gender,dob,age,mobile,email,password,address,height,weight,plan_id,join_date,expiry_date) values(?,?,?,?,?,?,?,?,?,?,?,?,?)"

);

ps.setString(1,name);
ps.setString(2,gender);
ps.setString(3,dob);
ps.setInt(4,Integer.parseInt(age));
ps.setString(5,mobile);
ps.setString(6,email);
ps.setString(7,encPassword);
ps.setString(8,address);
ps.setDouble(9,Double.parseDouble(height));
ps.setDouble(10,Double.parseDouble(weight));
ps.setInt(11,Integer.parseInt(plan));
ps.setDate(12,joinDate);
ps.setDate(13,expiryDate);

int i=ps.executeUpdate();

if(i>0){

response.sendRedirect("login.jsp?success=1");
return;

}else{

msg="Registration Failed.";

}

ps.close();

}

rs.close();

check.close();

con.close();

}catch(Exception e){

msg=e.getMessage();

}

}
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
