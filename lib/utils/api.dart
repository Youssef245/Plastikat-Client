const baseUrl = "http://164.92.248.132";
const apiUrl = "$baseUrl/api";

const itemsUrl = "$apiUrl/items"; // GET
const partnersUrl = "$apiUrl/partners"; // GET
const delegatesUrl = "$apiUrl/delegates"; // GET/PATCH
const offersUrl = "$apiUrl/offers"; // POST, PATCH
const exchangesUrl = "$apiUrl/exchanges"; // POST
const clientsUrl = "$apiUrl/clients"; // GET/POST/DELETE/PATCH

String clientByIdUrl(String id) => "$clientsUrl/$id";
String clientTokensUrl(String id) => "$clientsUrl/$id/tokens";
String clientExchangesUrl(String id) => "$clientsUrl/$id/exchanges";
String clientOffersUrl(String id) => "$clientsUrl/$id/offers";

String cancelOfferUrl(String id) => "$offersUrl/$id";
String createComplaint(String id) => "$clientsUrl/$id/complaints";

String delegateByIdUrl(String id) => "$delegatesUrl/$id";
String delegateOffersUrl(String id) => "$delegatesUrl/$id/offers";

String partnerByIdUrl(String id) => "$partnersUrl/$id";
String partnerRewardsUrl(String id) => "$partnersUrl/$id/rewards";
String partnerBranchesUrl(String id) => "$partnersUrl/$id/branches";