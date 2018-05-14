if [ "$#" -ne 3 ]
then
  echo "Usage: source assume_role.sh [account_id] [role] [base_account_id]"
  exit 1
fi

ACCOUNT="$1"
ROLE="$2"
BASE="$3"

role_session_name=`uuidgen || date | md5su | cut -d " " -f 1`
aws_creds=$(aws --profile ${BASE} sts assume-role --role-arn arn:aws:iam::${ACCOUNT}:role/$ROLE --role-session-name $role_session_name --duration-seconds 3600 --output json)

if [ "$?" -ne 0 ]
then
  exit 1
fi

export AWS_ACCESS_KEY_ID=$(echo $aws_creds | jq -r '.Credentials.AccessKeyId' )
export AWS_SECRET_ACCESS_KEY=$(echo $aws_creds | jq -r '.Credentials.SecretAccessKey' )
export AWS_SESSION_TOKEN=$(echo $aws_creds | jq -r '.Credentials.SessionToken' )
echo "session '$role_session_name' valid for 60 minutes"
