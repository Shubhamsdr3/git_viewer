
class DialogRequest{

}

class DialogResponse{

}


class AlertRequest extends DialogRequest {
  final String title;
  final String description;
  final String buttonTitle;

  AlertRequest({
    this.title,
    this.description,
    this.buttonTitle,
  });
}

class AlertResponse extends DialogResponse{
  final String fieldOne;
  final String fieldTwo;
  final bool confirmed;

  AlertResponse({
    this.fieldOne,
    this.fieldTwo,
    this.confirmed,
  });
}



class ChangeGitRepoRequest extends DialogRequest {
}

class ChangeGitRepoResponse extends DialogResponse{
  final String userName;
  final String projectName;
  final bool confirmed;

  ChangeGitRepoResponse({
    this.userName,
    this.projectName,
    this.confirmed,
  });
}