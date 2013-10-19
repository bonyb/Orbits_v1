package com.user.project;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class DeleteProjectServlet
 */
@WebServlet("/DeleteProjectServlet")
public class DeleteProjectServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public DeleteProjectServlet() {
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
		String projectId=request.getParameter("projectId");
		System.out.println("parentId--" + projectId);
		HttpSession session = request.getSession(true);
		int personID = 0;
		if (null != session.getAttribute("userID")) {
			// In session
			personID = Integer.parseInt(session.getAttribute("userID")
					.toString());
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager
						.getConnection("jdbc:mysql://localhost:3306/test");
				// Connection con =
				// DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"
				// +"user=orbits&password=orbits");
				
				java.sql.PreparedStatement  stat1 = con.prepareStatement("DELETE FROM VoteNodeCon WHERE ProjectID='" + projectId + "'");
				stat1.executeUpdate();
				stat1 = con.prepareStatement("DELETE FROM VoteModTracker WHERE ProjectID='" + projectId + "'");
				stat1.executeUpdate();
				stat1 = con.prepareStatement("Delete from UpDownVote where ProjectID='" + projectId + "'");
				stat1.executeUpdate();
				// find all the nodes from the tree where projectid=projectId
				java.sql.PreparedStatement stat = con.prepareStatement("select NodeID from Node where ProjectID='"+ projectId + "'");
					ResultSet result = stat.executeQuery();
					while(result.next()){
						stat1 = con.prepareStatement("Delete from NodeTagsCon where NodeID='" + result.getString(1) + "'");
						stat1.executeUpdate();
						stat1 = con.prepareStatement("Delete from NodeConvo where NodeID='" + result.getString(1) + "'");
						stat1.executeUpdate();
					}
				stat1 = con.prepareStatement("Delete from Node where ProjectID='" + projectId + "'");
				stat1.executeUpdate();
				stat1 = con.prepareStatement("Delete from PersonTreeCon where ProjectID='" + projectId + "'");
				stat1.executeUpdate();
				stat1 = con.prepareStatement("Delete from Tree where ProjectID='" + projectId + "'");
				stat1.executeUpdate();
				stat1.close();
				con.close();
				
				String aDestinationPage="AuthAndDisplayProjects";
				String urlWithSessionID = response.encodeRedirectURL(aDestinationPage.toString());
			    response.sendRedirect( urlWithSessionID );
				//RequestDispatcher dispatcher = request
				//		.getRequestDispatcher("/DisplayNodesServlet?projectId="+projectId+"&selectedNodeId="+nodeID);
				//dispatcher.forward(request, response);
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		}else{
			request.setAttribute("timedOut", "true");
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("index.jsp");
			dispatcher.forward(request, response);
		}
		

	
	}

}
