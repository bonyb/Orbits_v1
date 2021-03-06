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
import javax.servlet.http.HttpSession;

import com.node.display.DisplayNodesServlet;
import com.node.utilities.UtilityFunctionsImpl;

/**
 * Servlet implementation class CreateNewTree
 */
@WebServlet("/CreateNewTree")
public class CreateNewTree extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DisplayNodesServlet authLogin = new DisplayNodesServlet();
	private UtilityFunctionsImpl utility = new UtilityFunctionsImpl();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public CreateNewTree() {
       super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	System.out.println("When u can display all the trees");
	// get all the projects
	RequestDispatcher dispatcher = request.getRequestDispatcher("landingPage.jsp");
	dispatcher.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(true);
		if(null == session.getAttribute("userID")){
			// Timed out session
			request.setAttribute("timedOut", "true");
			RequestDispatcher dispatcher = request
					.getRequestDispatcher("index.jsp");
			dispatcher.forward(request, response);
			
		}else{
		String userId = session.getAttribute("userID").toString();
		String title = request.getParameter("title");
		String[] escapeTexts= utility.setEcsapeTitleDesc(title, null);
		try {
			String dt = utility.getCuttentDateTime();
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
//			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
			String contributorNotExistant=checkContributors(request,7);
			if(!contributorNotExistant.isEmpty()){
				request.setAttribute("nonExistantPerson", contributorNotExistant);
				RequestDispatcher dispatcher = request.getRequestDispatcher("AuthAndDisplayProjects");
				dispatcher.forward(request, response);
			}else{
			java.sql.PreparedStatement stat = con.prepareStatement("INSERT INTO Tree(Title,AuthorId,CreationTimeDate) VALUES ('"+ escapeTexts[0]+ "','"+ userId+ "','"+ dt+ "')");
			stat.executeUpdate();
			
			//get project Id
			java.sql.PreparedStatement stat2 = con.prepareStatement("Select ProjectID from Tree where Title='"+ escapeTexts[0]+ "' and AuthorID='"+ userId+ "' and CreationTimeDate='"+ dt+ "'");
			ResultSet result= stat2.executeQuery();
			result.first();
			String projectID=result.getString(1);
			
			// insert into Node table
			java.sql.PreparedStatement stat3 = con.prepareStatement("INSERT INTO Node(Title,AuthorId,CreationTimeDate,ProjectId,Parent,Levelno,countChildren,UpVote,DownVote) VALUES ('"+ escapeTexts[0]+ "','"+ userId+ "','"+ dt+ "',"+projectID+",0,1,0,0,0)");
			stat3.executeUpdate();
			
			//add the contributors to the project
			enterContributors(request, projectID,7);
			
			//get the nodeId that just got created
			java.sql.PreparedStatement stat4 = con.prepareStatement("Select NodeID from Node where ProjectId="+ projectID);
			ResultSet resultNode= stat4.executeQuery();
			resultNode.first();
			String nodeId=resultNode.getString(1);
			
			// insert the Visit =1 for the project
			java.sql.PreparedStatement stat5 = con.prepareStatement("INSERT into ProjectVisitHistory Values("+projectID+","+userId+",1)");
			stat5.executeUpdate();
			con.close();
			String aDestinationPage="DisplayNodesServlet?projectId="+projectID+"&selectedNodeId="+nodeId;
			String urlWithSessionID = response.encodeRedirectURL(aDestinationPage.toString());
			response.sendRedirect( urlWithSessionID );
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		}
	}

	/**
	 * Insert the contributors
	 * @param request
	 */
	public String checkContributors(HttpServletRequest request, Integer noOfCon) {
			String updateSuccess="";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
//			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		for(int i=1;i<=noOfCon;i++){
			String paramName= "person"+i;
			String name= request.getParameter(paramName);
			if(name.length() > 0 || !name.isEmpty()){
				//check if the name exists in the DB and get the personID
				java.sql.PreparedStatement stat2 = con.prepareStatement("Select PersonID from Person where Username='"+name.toLowerCase()+ "' OR Email='"+name+"'");
				ResultSet result= stat2.executeQuery();
				if(!result.next()){
					updateSuccess=name;
					break;
				}
			}
		}
		//java.sql.PreparedStatement stat2 = con.prepareStatement("INSERT INTO PersonTreeCon VALUES ("+ projectID+","+ userId+ ")");
		//stat2.executeUpdate();
		con.close();
		
		}catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
			return updateSuccess;

}
	
	/**
	 * Insert the contributors
	 * @param request
	 */
	public void enterContributors(HttpServletRequest request,String projectID, Integer noOfCon) {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
//			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		for(int i=1;i<=noOfCon;i++){
			String paramName= "person"+i;
			String name= request.getParameter(paramName);
			if(name.length() > 0 || !name.isEmpty()){
				//check if the name exists in the DB and get the personID
				java.sql.PreparedStatement stat2 = con.prepareStatement("Select PersonID from Person where Username='"+name.toLowerCase()+ "' OR Email='"+name+"'");
				ResultSet result= stat2.executeQuery();
				while(result.next()){
					java.sql.PreparedStatement stat = con.prepareStatement("INSERT INTO PersonTreeCon VALUES ("+ projectID+","+ result.getInt(1)+ ")");
					stat.executeUpdate();
				}
			}
		}
		//java.sql.PreparedStatement stat2 = con.prepareStatement("INSERT INTO PersonTreeCon VALUES ("+ projectID+","+ userId+ ")");
		//stat2.executeUpdate();
		con.close();
		
		}catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
	}

}
