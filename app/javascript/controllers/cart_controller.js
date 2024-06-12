import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["productId"];

  addToCart() {
    let productId = this.productIdTarget.value;

    fetch(`/cart_items?product_id=${productId}`, { method: "POST" })
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
      });
  }
}