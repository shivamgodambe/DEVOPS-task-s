resource "aws_iam_user" "u1" {
   name = "Shivam" 
}

resource "aws_iam_user" "u2" {
    name = "Rushi"
  
}

resource "aws_iam_user" "u3" {
    name = "gaurav"
}


resource "aws_iam_group" "g1" {
    name = "sherrs"
  
}

resource "aws_iam_group_membership" "grpadd" {
    name = "useradd"

    users = [
      aws_iam_user.u1.name,
      aws_iam_user.u2.name,
      aws_iam_user.u3.name
     
    ]

    group = aws_iam_group.g1.name
  
}




