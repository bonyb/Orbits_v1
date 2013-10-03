package com.node.downvote;

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
 * Servlet implementation class DownvoteServlet
 */
@WebServlet("/DownvoteServlet")
public class DownvoteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DownvoteServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String nodeID = request.getParameter("nodeID").toString();
		String projectId=request.getParameter("projectId");
		String aDestinationPage="DisplayNodesServlet?projectId="+projectId+"&selectedNodeId="+nodeID;
		String urlWithSessionID = response.encodeRedirectURL(aDestinationPage.toString());
	    response.sendRedirect( urlWithSessionID );
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String nodeID = request.getParameter("nodeID").toString();
		String projectId=request.getParameter("projectId");
		HttpSession session = request.getSession(true);
		int personID = 0;
		if (null != session.getAttribute("userID")) {
			// In session
			personID = Integer.parseInt(session.getAttribute("userID")
					.toString());
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
//				 Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
				// to get get the upvote count
				java.sql.PreparedStatement stat = con
						.prepareStatement("select DownVote from Node where NodeID='"
								+ nodeID + "'");
				ResultSet result = stat.executeQuery();
				result.first();
				int downvote = result.getInt(1);
				downvote++;
				java.sql.PreparedStatement stat1 = con
						.prepareStatement("UPDATE Node SET DownVote=" + downvote
								+ " Where NodeID='" + nodeID + "'");
				stat1.executeUpdate();
				stat.close();
				stat1.close();
				
				// to set donwvote and people
				stat = con
						.prepareStatement("select DownVote from UpDownVote where NodeID='"
								+ nodeID + "' and PersonID="+personID);
				result = stat.executeQuery();
				if(result.first()){
					downvote = result.getInt(1);
					downvote++;
					stat1 = con
							.prepareStatement("UPDATE UpDownVote SET DownVote=" + downvote
									+ " Where NodeID='" + nodeID + "' and PersonID="+personID);
					stat1.executeUpdate();
					stat.close();
					stat1.close();
				}else{
					stat1 = con
							.prepareStatement("INSERT into UpDownVote Values("+projectId+","+nodeID+","+personID+",0,1)");
					stat1.executeUpdate();
					stat.close();
					stat1.close();
					
				}
				
				con.close();
				
				
				String aDestinationPage="DisplayNodesServlet?projectId="+projectId+"&selectedNodeId="+nodeID;
				String urlWithSessionID = response.encodeRedirectURL(aDestinationPage.toString());
			    response.sendRedirect( urlWithSessionID );
			    
			    con.close();
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
