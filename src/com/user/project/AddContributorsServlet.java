package com.user.project;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddContributorsServlet
 */
@WebServlet("/AddContributorsServlet")
public class AddContributorsServlet extends HttpServlet {
	private CreateNewTree tree=new CreateNewTree();
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddContributorsServlet() {
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
		// TODO Auto-generated method stub
		
		// check the no f existing contributors
		String projectID= request.getParameter("projectId");
		Integer contributorNumber=Integer.parseInt(request.getParameter("contributorNumber"));
		try{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
//		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		
		String contributorNotExistant=tree.checkContributors(request,contributorNumber);
		if(!contributorNotExistant.isEmpty()){
			request.setAttribute("nonExistantPerson", contributorNotExistant);
			RequestDispatcher dispatcher = request.getRequestDispatcher("DisplayNodesServlet");
			dispatcher.forward(request, response);
		}else{
		
		
		//add the contributors to the project
		tree.enterContributors(request, projectID,contributorNumber);
		
		
		con.close();
		String aDestinationPage="DisplayNodesServlet?projectId="+projectID+"&selectedNodeId=";
		String urlWithSessionID = response.encodeRedirectURL(aDestinationPage.toString());
		response.sendRedirect( urlWithSessionID );
		}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}

}
