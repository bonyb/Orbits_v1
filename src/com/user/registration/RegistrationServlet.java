package com.user.registration;

import java.io.IOException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.node.utilities.UtilityFunctionsImpl;

/**
 *  Servlet implementation class RegistrationServlet
 */
@WebServlet("/RegistrationServlet")
public class RegistrationServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UtilityFunctionsImpl utility = new UtilityFunctionsImpl();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RegistrationServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(true);
			int userID=0;
			String firstName = request.getParameter("firstName");
			String lastName = request.getParameter("lastName");
			String email = request.getParameter("email");
			String username = request.getParameter("username").toLowerCase();
			String password = request.getParameter("password");
			
			try {
				if(firstName.isEmpty() || lastName.isEmpty() || email.isEmpty() || username.isEmpty() || password.isEmpty()){
					// Mandatory fields
					request.setAttribute("mandatory", "none");
					RequestDispatcher dispatcher = request
							.getRequestDispatcher("index.jsp");
					dispatcher.forward(request, response);
				}else{
				userID = register(firstName,lastName,email,username, password,request);
				if (userID == 0) {
				// Wrong user name and password
				RequestDispatcher dispatcher = request
						.getRequestDispatcher("index.jsp");
				dispatcher.forward(request, response);
					} else {
				//correct authentication
				session.setAttribute("userID", userID);
				session.setAttribute("username", username);
				session.setAttribute("name", firstName.concat(" "+lastName));
//				String aDestinationPage="landingPage.jsp";
//				String urlWithSessionID = response.encodeRedirectURL(aDestinationPage.toString());
//			    response.sendRedirect( urlWithSessionID );
				RequestDispatcher dispatcher = request.getRequestDispatcher("landingPage.jsp");
				dispatcher.forward(request, response);
			}
				}
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	
	}
	
	private int register(String firstName,String lastName,String email, String username,String password,HttpServletRequest request) throws ParseException{
		int status=0;
		try {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con;
		con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
		// Connection con =
		// DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"
		// +"user=orbits&password=orbits");
		
		// check for unique username and email
		
		java.sql.PreparedStatement stat2 = con.prepareStatement("select PersonID from Person where Email='"+ email + "'");
		ResultSet  result = stat2.executeQuery();
		while(result.next()){
			// email exists
			request.setAttribute("emailexists", "none");
			stat2.close();
			return status;
			
		}
		stat2 = con.prepareStatement("select PersonID from Person where Username='"+ username + "'");
		result = stat2.executeQuery();
		while(result.next()){
			// email exists
			request.setAttribute("usernameexists", "none");
			stat2.close();
			return status;
			
		}
		String encryptedPassword=utility.hashPassword(password);
		java.sql.PreparedStatement  stat1 = con.prepareStatement("INSERT into Person(Username,MyPassword,FirstName,LastName,Email,CreationDateTime,LastLogin) Values('"+username+"','"+encryptedPassword+"','"+firstName+"','"+lastName+"','"+email+"','"+utility.getCuttentDateTime()+"','"+utility.getCuttentDateTime()+"')");
		stat1.executeUpdate();
		stat1.close();
		java.sql.PreparedStatement stat3 = con.prepareStatement("select PersonID from Person where Email='"+ email + "'");
		ResultSet  person = stat3.executeQuery();
		person.first();
		status = person.getInt(1);
		stat3.close();
		con.close();
		}catch (ClassNotFoundException e) {
			request.setAttribute("regerror", "none");
			e.printStackTrace();
			status=0;
		}
		catch (SQLException e) {
			request.setAttribute("regerror", "none");
			e.printStackTrace();
			status=0;
		}
		return status;	
	}


}
