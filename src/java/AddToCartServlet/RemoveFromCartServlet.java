package AddToCartServlet; // 

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Iterator; 

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String productId = request.getParameter("productId");

        HttpSession session = request.getSession();
        
        @SuppressWarnings("unchecked") // Suppress warning for cast
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null && productId != null && !productId.trim().isEmpty()) {
            CartItem itemFoundAndRemoved = null;
            // Iterate and remove the item. Using Iterator is safer if modifying list during iteration.
            // However, for simple removal of one item by ID, finding it first then removing is also common.
            // Java 8 streams offer a concise way:
            // boolean removed = cart.removeIf(item -> item.getId().equals(productId));

            // Traditional iteration to find and get item name before removal
            for (Iterator<CartItem> iterator = cart.iterator(); iterator.hasNext();) {
                CartItem item = iterator.next();
                if (item.getId().equals(productId)) {
                    itemFoundAndRemoved = item; // Store for message
                    iterator.remove(); // Safe removal using iterator
                    break; 
                }
            }
            
            if (itemFoundAndRemoved != null) {
                session.setAttribute("cartMessage", "Item '" + itemFoundAndRemoved.getName() + "' removed from cart.");
            } else {
                session.setAttribute("cartError", "Item not found in cart to remove.");
            }
            session.setAttribute("cart", cart); // Update the cart in session
        } else {
            if (cart == null) {
                session.setAttribute("cartError", "Cart is not initialized.");
            } else {
                session.setAttribute("cartError", "Product ID for removal is missing.");
            }
        }

        response.sendRedirect("cart.jsp"); 
    }
}