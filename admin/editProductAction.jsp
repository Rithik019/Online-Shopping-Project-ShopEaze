<%@page import="Project.ConnectionProvider"%>
<%@page import="java.sql.*"%>
<%
String id = request.getParameter("id");
String name = request.getParameter("name");
String category = request.getParameter("category");
String price = request.getParameter("price");
String active = request.getParameter("active");

Connection con = null;
PreparedStatement pst = null;
PreparedStatement deletePst = null;

try {
    con = ConnectionProvider.getCon();
    
    // Update product details
    String updateQuery = "UPDATE product SET name=?, category=?, price=?, active=? WHERE id=?";
    pst = con.prepareStatement(updateQuery);
    pst.setString(1, name);
    pst.setString(2, category);
    pst.setString(3, price);
    pst.setString(4, active);
    pst.setString(5, id);
    pst.executeUpdate();

    // If the product is deactivated (active = "No"), delete from cart
    if ("No".equals(active)) {
        String deleteQuery = "DELETE FROM cart WHERE product_id=? AND address IS NULL";
        deletePst = con.prepareStatement(deleteQuery);
        deletePst.setString(1, id);
        deletePst.executeUpdate();
    }

    response.sendRedirect("allProductEditProduct.jsp?msg=done");
} catch (Exception e) {
    e.printStackTrace(); // Log the exception for debugging
    response.sendRedirect("allProductEditProduct.jsp?msg=wrong");
} finally {
    // Close resources
    try {
        if (pst != null) pst.close();
        if (deletePst != null) deletePst.close();
        if (con != null) con.close();
    } catch (SQLException ex) {
        ex.printStackTrace();
    }
}
%>
