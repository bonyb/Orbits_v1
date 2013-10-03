package com.node.priority;

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
import javax.servlet.http.HttpSession;

import com.node.utilities.UtilityFunctionsImpl;

/**
 * Servlet implementation class ImportanceVoteServlet
 */
@WebServlet("/ImportanceVoteServlet")
public class ImportanceVoteServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UtilityFunctionsImpl utility = new UtilityFunctionsImpl();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ImportanceVoteServlet() {
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
		int personID=0;
		if (null != session.getAttribute("userID")) {
			// already authenticated
		personID = Integer.parseInt(session.getAttribute("userID").toString());
		String nodeID = request.getParameter("nodeID").toString();
		String projectId=request.getParameter("projectId");
		try {
		int voteId=Integer.parseInt(request.getParameter("vote"));
		String dt = utility.getCuttentDateTime();
		System.out.println("voteId--" + voteId);
		
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
//			 Connection con =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
			// to check if that person had voted on this node before
			java.sql.PreparedStatement stat = con
					.prepareStatement("select VoteId from VoteNodeCon where NodeID='"
							+ nodeID + "' and AuthorID="+personID+" and ProjectID="+projectId);
			ResultSet result = stat.executeQuery();
			if(result.next()){
				// is there, update
				java.sql.PreparedStatement stat1 = con
				.prepareStatement("UPDATE VoteNodeCon SET VoteId=" + voteId
						+ ",LastModified='"+dt+"'  Where NodeID='" + nodeID + "' and AuthorID="+personID+" and ProjectID="+projectId);
				stat1.executeUpdate();
				stat1.close();
			}else{
				// not there insert
				java.sql.PreparedStatement stat1 = con
				.prepareStatement("INSERT INTO VoteNodeCon VALUES ("
						+ projectId + "," + nodeID + ","+personID+","+voteId+",'"+dt+"')");
				stat1.executeUpdate();
			    stat1.close();
			}
			stat.close();
			
			// insert in the voteTracker
			java.sql.PreparedStatement stat1 = con
			.prepareStatement("INSERT INTO VoteModTracker VALUES ("
					+ projectId + "," + nodeID + ","+personID+","+voteId+",'"+dt+"')");
			stat1.executeUpdate();
			stat1.close();
			con.close();
			String aDestinationPage="DisplayNodesServlet?projectId="+projectId+"&selectedNodeId="+nodeID;
			String urlWithSessionID = response.encodeRedirectURL(aDestinationPage.toString());
		    response.sendRedirect( urlWithSessionID );
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
		}
		}else{
			
			request.setAttribute("timedOut", "true");
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("index.jsp");
			dispatcher.forward(request, response);
		}

	}

	
	}

