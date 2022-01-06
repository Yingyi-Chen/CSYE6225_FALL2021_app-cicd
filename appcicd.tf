
provider "aws" {
  region  = var.REGION
  profile = var.PROFILE
}

//Assignment 5

data "aws_iam_user" "ghactions-app" {
  user_name = "ghactions-app"
}

#github actions user policy 
resource "aws_iam_user_policy" "GH-Upload-To-S3" {

  name = "GH-Upload-To-S3"
  user = data.aws_iam_user.ghactions-app.user_name

  policy = jsonencode(
    {
      "Version" : "2012-10-17"
      "Statement" : [
        {
          "Effect" : "Allow"
          "Action" : [
            "s3:PutObject",
            "s3:Get*",
            "s3:List*",
            "s3:CreateMultipartUpload"
          ]
          "Resource" : [
            "arn:aws:s3:::codedeploy.${var.PROFILE}.yingyi.me/*",
            "arn:aws:s3:::codedeploy.${var.PROFILE}.yingyi.me"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_user_policy" "GH-Code-Deploy" {
  name = "GH-Code-Deploy"
  user = data.aws_iam_user.ghactions-app.user_name

  policy = jsonencode(
    {
      "Version" : "2012-10-17"
      "Statement" : [
        {
          "Effect" : "Allow"
          "Action" : [
            "codedeploy:RegisterApplicationRevision",
            "codedeploy:GetApplicationRevision"
          ],
          "Resource" : [
            "arn:aws:codedeploy:${var.REGION}:${var.AWSaccountID}:application:${var.codeDeployappName}"
          ]
        },
        {
          "Effect" : "Allow"
          "Action" : [
            "codedeploy:CreateDeployment",
            "codedeploy:GetDeployment"
          ],
          "Resource" : [
            "arn:aws:codedeploy:${var.REGION}:${var.AWSaccountID}:deploymentgroup:${var.codeDeployappName}/${var.codeDeployDGname}"
          ]
        },
        {
          "Effect" : "Allow"
          "Action" : [
            "codedeploy:GetDeploymentConfig"
          ],
          "Resource" : [
            "arn:aws:codedeploy:${var.REGION}:${var.AWSaccountID}:deploymentconfig:CodeDeployDefault.OneAtATime",
            "arn:aws:codedeploy:${var.REGION}:${var.AWSaccountID}:deploymentconfig:CodeDeployDefault.HalfAtATime",
            "arn:aws:codedeploy:${var.REGION}:${var.AWSaccountID}:deploymentconfig:CodeDeployDefault.AllAtOnce"
          ]
        }
      ]
    }
  )
}

//assignment7
resource "aws_iam_user_policy" "GH-Upload-To-S3-serverless" {

  name = "GH-Upload-To-S3-serverless"
  user = data.aws_iam_user.ghactions-app.user_name

  policy = jsonencode(
    {
      "Version" : "2012-10-17"
      "Statement" : [
        {
          "Effect" : "Allow"
          "Action" : [
            "s3:PutObject",
            "s3:Get*",
            "s3:List*"
          ]
          "Resource" : [
            "arn:aws:s3:::lambda.${var.PROFILE}.yingyi.me/*",
            "arn:aws:s3:::lambda.${var.PROFILE}.yingyi.me"
          ]
        }
      ]
    }
  )
}

resource "aws_iam_user_policy" "GH-S3-serverless" {
  name = "GH-S3-serverless"
  user = data.aws_iam_user.ghactions-app.user_name

  policy = jsonencode(
    {
      "Version" : "2012-10-17"
      "Statement" : [
        {
          "Effect" : "Allow"
          "Action" : [
            "lambda:UpdateFunctionCode"
          ],
          "Resource" : [
            "arn:aws:lambda:${var.REGION}:${var.AWSaccountID}:function:${var.lambdaName}"
            
          ]
        }
      ]
    }
  )
}























