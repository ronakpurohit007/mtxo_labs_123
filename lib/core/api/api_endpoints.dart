class ApiEndpoints {
  //static const String baseUrl = 'http://jayrajfrontend.ap.loclx.io';
  // static const String baseUrl = 'https://shailesh.ap.loclx.io';
  static const String baseUrl = 'https://mordernera.com';
  // static const String baseUrl = 'https://pucho.ai';
  // static const String baseUrl = 'http://jayrajfrontend.ap.loclx.io';
  static const String aiBaseUrl = 'https://devapi.pucho.ai/api';
  // static const String aiBaseUrl = 'https://api.pucho.ai/api';
  // static const String aiBaseUrl = 'http://rajbackend.ap.loclx.io/api';
  static const String DiffybaseUrl = 'https://agentflow.puchho.ai/';

  //my new api

  static const String login = '$baseUrl/api/auth/login';

  static const String register = '$baseUrl/api/auth/register';
  static const String logout = '$baseUrl/api/auth/logout';
  static const String forgotPassword = '$baseUrl/api/auth/forgot-password';

  /////////////////////////////////////////////////////////////

  // static const String getData = '$baseUrl/data';
  static const String getUserdata = '$baseUrl/api/auth/session';
  static const String createchat = '$baseUrl/api/v1/chat';
  static const String saveanswer = '$baseUrl/api/v1/chat/answer';
  static const String saveadditionaldata =
      '$baseUrl/api/v1/chat/additional-data';
  static const String chatstream = '$aiBaseUrl/v1/experiment/answer/stream';
  static const String nostatechatstream =
      '$aiBaseUrl/v1/chat/create/no-state/stream';
  static const String titlecreate = '$aiBaseUrl/v1/search/title';
  static const String diffystream = '${DiffybaseUrl}v1/chat-messages';

  static String saveQuestion(String chatId) {
    return "$baseUrl/api/v1/chat/$chatId/question";
  }

  // static String chathistory(ChatHistoryRequest chatHistoryRequest) {
  //   return "$baseUrl/api/v1/chat?chatType=${chatHistoryRequest.chatType}&orgUserId=${chatHistoryRequest.orgUserId}&page=${chatHistoryRequest.page}&perPage=${chatHistoryRequest.perPage}";
  // }

  static String getUserAgents(String userID) {
    return '$baseUrl/api/v1/connection/userfolder?userId=$userID';
  }

  static String getNotebookFolders(String userId, String organizationId) {
    return '$baseUrl/api/v1/notebook/folder?organizationId=$organizationId&userId=$userId';
  }

  // static String createUserAgent() {
  //   return '$baseUrl/api/v1/connection/userfolder/create';
  // }

  static String createUserAgent() {
    return '$baseUrl/api/v1/notebook/folder';
  }

  static const String checkPassword = '$baseUrl/api/v1/profile/check-password';
  static const String updateprofile = '$baseUrl/api/v1/profile';
  static const String researcharea =
      '$baseUrl/api/v1/personalize/research-area';
  static const String researchareaadd =
      '$baseUrl/api/v1/personalize/research-area/researchAreas';
  static const String responsestyle =
      '$baseUrl/api/v1/personalize/response-style';

  static String getChatHistory(String chatId) {
    return '$baseUrl/api/v1/chat/$chatId';
  }

  static String getCheckFileStatus(String chatId, String userId) {
    return '$baseUrl/api/v1/chat/$chatId/question?userId=$userId';
  }

  static String updateChatHistoryTitle(String id) {
    return '$baseUrl/api/v1/chat/$id';
  }

  static String updateChatHistoryDelete(String id) {
    return '$baseUrl/api/v1/chat/$id';
  }

  static const String uploadfile = '$baseUrl/api/v1/upload_file';

  static String suggestionContent(String language, String count) {
    return '$baseUrl/api/v1/suggestion-question?lang=$language&count=$count';
  }

  static String chatlike(String answerId) {
    return "$baseUrl/api/v1/chat/answer/$answerId";
  }

  static const String dislike = '$baseUrl/api/v1/chat/report';
  static const String updatemapcount = '$baseUrl/api/v1/updatemapcount';

  static const String fetchImages = '$aiBaseUrl/v1/search/images';
  static const String fetchVideos = '$aiBaseUrl/v1/search/videos';
  static const String chatLanguage = '$baseUrl/api/v1/language';

  static const String queries = '$aiBaseUrl/v1/deep-research/queries';
  static const String searchRun =
      '$aiBaseUrl/v1/deep-research/queries/search-run';
  static const String finalReport = '$aiBaseUrl/v1/deep-research/final-report';
}
