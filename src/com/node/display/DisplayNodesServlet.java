package com.node.display;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.ws.rs.core.MultivaluedMap;

import org.apache.cxf.jaxrs.impl.MetadataMap;

import com.node.utilities.UtilityFunctionsImpl;

/**
 * Servlet implementation class AuthLogin
 */
@WebServlet("/DisplayNodesServlet")
public class DisplayNodesServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UtilityFunctionsImpl utility = new UtilityFunctionsImpl();

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public DisplayNodesServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		this.doPost(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub

		String projectId = request.getParameter("projectId");
		String selectedNodeId = request.getParameter("selectedNodeId");
		String log = request.getParameter("log");

		HttpSession session = request.getSession(true);
		int personID = 0;
		if (null != session.getAttribute("userID")) {
			// already authenticated
			personID = Integer.parseInt(session.getAttribute("userID")
					.toString());
			try {
				HashMap<String, List<String>> nodemap = displayResults(
						personID, projectId);
				if (!nodemap.isEmpty()) {
					setAttributes(personID, nodemap, request, response,
							projectId, selectedNodeId,
							noofContributors(projectId),
							contributorsList(projectId));
				} else {
					// no projects
					RequestDispatcher dispatcher = request
							.getRequestDispatcher("main.jsp");
					dispatcher.forward(request, response);
				}
				incrementProjectVisitCount(log,personID, projectId);
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} else {
			// needs to be authenticated
			try {
				String username = request.getParameter("username");
				String password = request.getParameter("password");
				personID = authLogin(username, password);
				if (personID == 0) {
					request.setAttribute("results", "none");
					RequestDispatcher dispatcher = request
							.getRequestDispatcher("index.jsp");
					dispatcher.forward(request, response);

				} else {
					HttpSession newsession = request.getSession(false);
					newsession.setAttribute("userID", personID);
					HashMap<String, List> hashMap = new HashMap<String, List>();
					try {
						setAttributes(personID,
								displayResults(personID, projectId), request,
								response, projectId, selectedNodeId,
								noofContributors(projectId),
								contributorsList(projectId));

					} catch (ClassNotFoundException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (SQLException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			} catch (ClassNotFoundException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			} catch (SQLException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
		}

	}

	/**
	 * increment the number of time
	 * 
	 * @param projectId
	 * @return
	 */
	private void incrementProjectVisitCount(String log,int personID,String projectID) {
		// check if user enters project
		if(null!=log){
			int visitCount=0;
		// increment the count in PersonTreeCon or Tree if author
			// update the votes with names
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test");
				// Connection con =
				// DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"
				// +"user=orbits&password=orbits");
				java.sql.PreparedStatement stat = con.prepareStatement("select VisitCount from ProjectVisitHistory where ProjectID='"+ projectID + "' and PersonID="+personID);
				ResultSet result = stat.executeQuery();
				if(result.first()){
					// increment in the value
					visitCount=result.getInt(1);
					visitCount++;
					java.sql.PreparedStatement stat1 = con.prepareStatement("UPDATE ProjectVisitHistory SET VisitCount=" + visitCount
							+ " Where ProjectID='" + projectID + "' and PersonID="+personID);
					stat1.executeUpdate();
				}else{
					// insert the value
					java.sql.PreparedStatement stat1 = con.prepareStatement("INSERT into ProjectVisitHistory Values("+projectID+","+personID+",1)");
					stat1.executeUpdate();
					
				}
				
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

	int authLogin(String username, String password)
			throws ClassNotFoundException, SQLException {

		int parseInt = 0;
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager
				.getConnection("jdbc:mysql://localhost:3306/test");
		// Connection con =
		// DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		java.sql.PreparedStatement stat = con
				.prepareStatement("select PersonID from Person where Username='"
						+ username + "' and MyPassword='" + password + "'");
		ResultSet result = stat.executeQuery();
		while (result.next()) {
			parseInt = Integer.parseInt(result.getString(1));
		}

		con.close();
		return parseInt;
		// return ((Number) result.getObject(1)).intValue();
	}

	/**
	 * check and return the max level of the tree
	 * 
	 * @param projectId
	 * @return
	 */
	int noofContributors(String projectId) {
		int level = 0;
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager
					.getConnection("jdbc:mysql://localhost:3306/test");
			// Connection con
			// =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
			java.sql.PreparedStatement stat = con
					.prepareStatement("select COUNT(*) from PersonTreeCon where ProjectID='"
							+ projectId + "'");
			ResultSet result = stat.executeQuery();
			while (result.next()) {
				level = result.getInt(1);
			}
			stat.close();
			con.close();
			return level;
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return level;
	}

	/**
	 * return the list of contributors
	 * 
	 * @param projectId
	 * @return
	 */
	String contributorsList(String projectId) {
		String names = "";
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager
					.getConnection("jdbc:mysql://localhost:3306/test");
			// Connection con
			// =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
			java.sql.PreparedStatement stat = con
					.prepareStatement("select PersonID from PersonTreeCon where ProjectID='"
							+ projectId + "'");
			ResultSet result = stat.executeQuery();
			while (result.next()) {
				String personID = result.getString(1);
				java.sql.PreparedStatement stat1 = con
						.prepareStatement("select * from Person where PersonID='"
								+ personID + "'");
				ResultSet personDet = stat1.executeQuery();
				personDet.first();
				String pname = personDet.getString("FirstName") + " "
						+ personDet.getString("LastName") + ",";
				names = names.concat(pname);
				stat1.close();
			}
			stat.close();
			con.close();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return names;
	}

	HashMap<String, List<String>> displayResults(int personId, String projectId)
			throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager
				.getConnection("jdbc:mysql://localhost:3306/test");
		// Connection con
		// =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		// java.sql.PreparedStatement stat=
		// con.prepareStatement("select * from Node where AuthorId='"+personId+"' order by Parent ASC");
		java.sql.PreparedStatement stat = con
				.prepareStatement("select * from Node where ProjectId='"
						+ projectId + "' order by Parent ASC");
		ResultSet result = stat.executeQuery();
		HashMap<String, List<String>> hashMap = new HashMap<String, List<String>>();
		if (null != result) {
			while (result.next()) {
				List<String> messages = new ArrayList<String>();
				messages.add(result.getString(2));
				messages.add(result.getString(3));
				messages.add(result.getString(5));
				messages.add(result.getString(6));
				messages.add(result.getString(7));
				// add the author id
				String authorId = result.getString(4);
				java.sql.PreparedStatement authorname = con
						.prepareStatement("select Username from Person where PersonID='"
								+ authorId + "'");
				ResultSet personname = authorname.executeQuery();
				personname.first();
				// add author name
				String displayAuthorname = personname.getString(1);
				StringBuilder sb = new StringBuilder(displayAuthorname);
				sb.replace(0, 1, sb.substring(0, 1).toUpperCase());
				messages.add(sb.toString());
				// also add the author Id
				messages.add(authorId);
				// add upvote and downvote -- TODO

				messages.add(result.getString(8));
				messages.add(result.getString(9));
				// Arrays.asList(result.getString(2),
				// result.getString(3),result.getString(5),result.getString(6),result.getString(7));
				String nodeId = result.getString(1);
				// Get and set the time
				String dt = result.getString(10);
				messages.add(utility.setDisplayTime(dt));
				// Get related votes
				retrieveVotes(nodeId, personId, messages);
				// get the up and down votes with names
				setUpVoteDetails(nodeId, messages);
				setDownVoteDetails(nodeId, messages);

				// Get the related Tags
				retrieveTags(nodeId, messages);
				hashMap.put(nodeId, messages);
			}
		}

		con.close();
		return hashMap;
	}

	/**
	 * Retrieve Tags
	 * 
	 * @param nodeId
	 * @param messages
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	void retrieveTags(String nodeId, List<String> messages)
			throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager
				.getConnection("jdbc:mysql://localhost:3306/test");
		// Connection con
		// =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		java.sql.PreparedStatement stat = con
				.prepareStatement("select TagID from NodeTagsCon where NodeID='"
						+ nodeId + "'");
		ResultSet tableTagids = stat.executeQuery();
		if (!tableTagids.wasNull()) {
			while (tableTagids.next()) {
				int Tagid = tableTagids.getInt(1);
				java.sql.PreparedStatement stat1 = con
						.prepareStatement("select Tagname from Tags where TagID='"
								+ Tagid + "'");
				ResultSet tags = stat1.executeQuery();
				tags.first();
				String tagnameMsg = tags.getString(1);
				// messages.add("tagnameMsg");
				messages.add(tagnameMsg);
			}
		}

		con.close();
	}

	/**
	 * Set up vote details
	 * 
	 * @param nodeId
	 * @param messages
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	void setUpVoteDetails(String nodeId, List<String> messages)
			throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager
				.getConnection("jdbc:mysql://localhost:3306/test");
		// Connection con
		// =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		java.sql.PreparedStatement stat = con
				.prepareStatement("select PersonID,UpVote from UpDownVote where NodeID='"
						+ nodeId + "' and UpVote > 0");
		ResultSet upvoteDetails = stat.executeQuery();
		if (!upvoteDetails.wasNull()) {
			String nameList = "Guest.1";
			while (upvoteDetails.next()) {
				// get user name
				int personID = upvoteDetails.getInt(1);
				java.sql.PreparedStatement stat1 = con
						.prepareStatement("select Username from Person where PersonID='"
								+ personID + "'");
				ResultSet name = stat1.executeQuery();
				name.first();
				String username = name.getString(1);
				stat1.close();

				// get up vote count
				String upVote = upvoteDetails.getString(2);
				nameList = nameList.concat(username + "." + upVote + "#");
			}
			messages.add(nameList);
		}

		con.close();
	}

	/**
	 * Set down vote details
	 * 
	 * @param nodeId
	 * @param messages
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	void setDownVoteDetails(String nodeId, List<String> messages)
			throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager
				.getConnection("jdbc:mysql://localhost:3306/test");
		// Connection con
		// =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		java.sql.PreparedStatement stat = con
				.prepareStatement("select PersonID,DownVote from UpDownVote where NodeID='"
						+ nodeId + "' and DownVote > 0");
		ResultSet upvoteDetails = stat.executeQuery();
		if (!upvoteDetails.wasNull()) {
			String nameList = "Guest.1";
			while (upvoteDetails.next()) {
				// get user name
				int personID = upvoteDetails.getInt(1);
				java.sql.PreparedStatement stat1 = con
						.prepareStatement("select Username from Person where PersonID='"
								+ personID + "'");
				ResultSet name = stat1.executeQuery();
				name.first();
				String username = name.getString(1);
				stat1.close();

				// get up vote count
				String downVote = upvoteDetails.getString(2);
				nameList = nameList.concat(username + "." + downVote + "#");
			}
			messages.add(nameList);
		}

		con.close();
	}

	/**
	 * retrieve Votes
	 * 
	 * @param nodeId
	 * @param messages
	 * @throws ClassNotFoundException
	 * @throws SQLException
	 */
	void retrieveVotes(String nodeId, int authorId, List<String> messages)
			throws ClassNotFoundException, SQLException {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager
				.getConnection("jdbc:mysql://localhost:3306/test");
		// Connection con
		// =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		// get -1 votes
		java.sql.PreparedStatement stat = con
				.prepareStatement("select count(*) from VoteNodeCon where NodeID='"
						+ nodeId + "' and VoteId=-1");
		ResultSet lowest = stat.executeQuery();
		lowest.first();
		Integer low = lowest.getInt(1);
		messages.add(low.toString());
		stat.close();

		java.sql.PreparedStatement stat1 = con
				.prepareStatement("select count(*) from VoteNodeCon where NodeID='"
						+ nodeId + "' and VoteId=1");
		lowest = stat1.executeQuery();
		lowest.first();
		low = lowest.getInt(1);
		messages.add(low.toString());
		stat1.close();

		java.sql.PreparedStatement stat2 = con
				.prepareStatement("select count(*) from VoteNodeCon where NodeID='"
						+ nodeId + "' and VoteId=2");
		lowest = stat2.executeQuery();
		lowest.first();
		low = lowest.getInt(1);
		messages.add(low.toString());
		stat2.close();

		java.sql.PreparedStatement stat3 = con
				.prepareStatement("select count(*) from VoteNodeCon where NodeID='"
						+ nodeId + "' and VoteId=3");
		lowest = stat3.executeQuery();
		lowest.first();
		low = lowest.getInt(1);
		messages.add(low.toString());
		stat3.close();

		java.sql.PreparedStatement stat4 = con
				.prepareStatement("select count(*) from VoteNodeCon where NodeID='"
						+ nodeId + "' and VoteId=4");
		lowest = stat4.executeQuery();
		lowest.first();
		low = lowest.getInt(1);
		messages.add(low.toString());
		stat4.close();

		// store the user's vote
		java.sql.PreparedStatement stat5 = con
				.prepareStatement("select VoteId from VoteNodeCon where NodeID='"
						+ nodeId + "' and AuthorID=" + authorId);
		lowest = stat5.executeQuery();
		Integer myVote = 0;
		if (lowest.first()) {
			myVote = lowest.getInt(1);
		}
		messages.add(myVote.toString());
		stat5.close();
		con.close();
	}

	void setAttributes(int personID, HashMap<String, List<String>> result,
			HttpServletRequest request, HttpServletResponse response,
			String projectId, String selectedNodeId, int noofContributors,
			String contributorsList) throws ServletException, IOException,
			ClassNotFoundException, SQLException {
		// find number of parents

		// create new set of hashmaps for nodes based on no of parents

		HashMap<String, List> hashMap0 = new HashMap<String, List>();
		HashMap<String, List> hashMap1 = new HashMap<String, List>();
		HashMap<String, List> hashMap2 = new HashMap<String, List>();
		HashMap<String, List> hashMap3 = new HashMap<String, List>();
		HashMap<String, List> hashMap4 = new HashMap<String, List>();
		HashMap<String, List> hashMap5 = new HashMap<String, List>();
		HashMap<String, List> hashMap6 = new HashMap<String, List>();
		HashMap<String, List> hashMap7 = new HashMap<String, List>();
		HashMap<String, List> hashMap8 = new HashMap<String, List>();
		HashMap<String, List> hashMap9 = new HashMap<String, List>();
		HashMap<String, List> hashMap10 = new HashMap<String, List>();
		HashMap<String, List> hashMap11 = new HashMap<String, List>();
		HashMap<String, List> hashMap12 = new HashMap<String, List>();
		HashMap<String, List> hashMap13 = new HashMap<String, List>();
		HashMap<String, List> hashMap14 = new HashMap<String, List>();
		HashMap<String, List> hashMap15 = new HashMap<String, List>();

		Iterator it = result.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry entry = (Map.Entry) it.next();
			// Integer key = (Integer)entry.getKey();
			List val = (List) entry.getValue();
			// sorting and dividing the list by level
			String parent = val.get(3).toString();

			switch (Integer.parseInt(parent)) {
			case 0: {

				hashMap0.put(entry.getKey().toString(), val);
				request.setAttribute("node0", hashMap0);
				break;
			}
			case 1: {

				hashMap1.put(entry.getKey().toString(), val);
				break;

			}
			case 2: {

				hashMap2.put(entry.getKey().toString(), val);
				break;

			}
			case 3: {

				hashMap3.put(entry.getKey().toString(), val);
				break;

			}
			case 4: {

				hashMap4.put(entry.getKey().toString(), val);
				break;

			}
			case 5: {

				hashMap5.put(entry.getKey().toString(), val);
				break;

			}
			case 6: {

				hashMap6.put(entry.getKey().toString(), val);
				break;

			}
			case 7: {

				hashMap7.put(entry.getKey().toString(), val);
				break;

			}
			case 8: {

				hashMap8.put(entry.getKey().toString(), val);
				break;

			}
			case 9: {

				hashMap9.put(entry.getKey().toString(), val);
				break;

			}
			case 10: {

				hashMap10.put(entry.getKey().toString(), val);
				break;

			}
			case 11: {

				hashMap11.put(entry.getKey().toString(), val);
				break;

			}
			case 12: {

				hashMap12.put(entry.getKey().toString(), val);
				break;

			}
			case 13: {

				hashMap13.put(entry.getKey().toString(), val);
				break;

			}
			case 14: {

				hashMap14.put(entry.getKey().toString(), val);
				break;

			}
			case 15: {

				hashMap15.put(entry.getKey().toString(), val);
				break;

			}
			}

		}

		// if(!flag1)
		request.setAttribute("node1", hashMap1);
		// if(!flag2)
		request.setAttribute("node2", hashMap2);
		// if(!flag3)
		request.setAttribute("node3", hashMap3);
		// if(!flag4)
		request.setAttribute("node4", hashMap4);
		// if(!flag5)
		request.setAttribute("node5", hashMap5);
		// if(!flag6)
		request.setAttribute("node6", hashMap6);
		// if(!flag7)
		request.setAttribute("node7", hashMap7);
		// if(!flag8)
		request.setAttribute("node8", hashMap8);
		request.setAttribute("node9", hashMap8);
		request.setAttribute("node10", hashMap8);
		request.setAttribute("node11", hashMap8);
		request.setAttribute("node12", hashMap8);
		request.setAttribute("node13", hashMap8);
		request.setAttribute("node14", hashMap8);
		request.setAttribute("node15", hashMap8);

		// setting the comments
		request.setAttribute("comments", retrieveComments());

		// means the node is selected from the projects page
		if (null == selectedNodeId || selectedNodeId.isEmpty()
				|| selectedNodeId.length() == 0) {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager
					.getConnection("jdbc:mysql://localhost:3306/test");
			// Connection con =
			// DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
			java.sql.PreparedStatement stat = con
					.prepareStatement("select NodeID from Node where ProjectId='"
							+ projectId + "' and Parent=0");
			ResultSet firstNode = stat.executeQuery();
			while (firstNode.next()) {
				selectedNodeId = firstNode.getString(1);
			}
			con.close();
		}
		request.setAttribute("c", noofContributors);
		request.setAttribute("conList", contributorsList);
		RequestDispatcher dispatcher = request
				.getRequestDispatcher("main.jsp?projectId=" + projectId
						+ "&selectedNodeId=" + selectedNodeId);
		dispatcher.forward(request, response);
	}

	MultivaluedMap<String, List<String>> retrieveComments()
			throws ClassNotFoundException, SQLException {
		MultivaluedMap<String, List<String>> commentMap = new MetadataMap<String, List<String>>();
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager
				.getConnection("jdbc:mysql://localhost:3306/test");
		// Connection con
		// =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");
		PreparedStatement stat = con
				.prepareStatement("select NodeID,CommentText,CreationTimeDate,AuthorID from NodeConvo");
		ResultSet commentsRes = stat.executeQuery();

		if (null != commentsRes) {
			while (commentsRes.next()) {
				List<String> commentDet = new ArrayList<String>();
				String nodeId = ((Integer) commentsRes.getInt(1)).toString();
				// add comment
				commentDet.add(commentsRes.getString(2));
				// add date
				commentDet
						.add(utility.setDisplayTime(commentsRes.getString(3)));
				// add author name
				Connection con1 = DriverManager
						.getConnection("jdbc:mysql://localhost:3306/test");
				// Connection con1
				// =DriverManager.getConnection("jdbc:mysql://localhost:3306/orbits?"+"user=orbits&password=orbits");

				PreparedStatement stat1 = con1
						.prepareStatement("select Username from Person where PersonID='"
								+ commentsRes.getString(4) + "'");
				ResultSet authorName = stat1.executeQuery();
				authorName.first();
				commentDet.add(authorName.getString(1));

				// Adding to the Map
				commentMap.add(nodeId, commentDet);
				con1.close();
			}
		}
		con.close();
		return commentMap;
	}

	ArrayList<Integer> noofparents(HashMap<String, List<String>> result) {
		Iterator it = result.entrySet().iterator();
		ArrayList<Integer> parents = new ArrayList<Integer>();
		while (it.hasNext()) {
			Map.Entry entry = (Map.Entry) it.next();
			// Integer key = (Integer)entry.getKey();
			List val = (List) entry.getValue();
			String dbParent = val.get(2).toString();
			Integer x = Integer.valueOf(dbParent);
			for (int i = 0; i <= parents.size(); i++) {
				if (!parents.contains(x)) {
					parents.add(x);
					break;
				}
			}

		}
		return parents;
	}

}
