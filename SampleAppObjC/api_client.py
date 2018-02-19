import requests
import json


class AdminPanelAPI(object):
    def __init__(self, skey="&*b~;?mH'@zQg>]n9SRx_>VY^(-uMpP+uYm7_@?H", base_url="http://pdxqalkyselenium01.iovationnp.com:6543/api/"):
        self.skey = skey
        self.base_url = base_url

    def _gen_hmac(self, content):
        import hmac, hashlib, base64
        data = json.dumps(content, sort_keys=True)
        mac = hmac.new(self.skey, data, digestmod=hashlib.sha256).digest()
        return base64.b64encode(mac)

    def _get_headers(self, content):
        return {
            "Authorization": self._gen_hmac(content),
            "Content_Type": "text/json",
        }

    def _post(self, api, data):
        # print("Performing POST request against: {0}".format(api))
        response = requests.post(self.base_url + api, data=json.dumps(data), headers=self._get_headers(data))
        response.raise_for_status()
        return response.json()

    def _get(self, api, data):
        # print("Performing GET request against: {0}".format(api))
        response = requests.get(self.base_url + api, params=data, headers=self._get_headers(data))
        response.raise_for_status()
        return response.json()

    def _put(self, api, data):
        # print("Performing PUT request against: {0}".format(api))
        response = requests.put(self.base_url + api, data=json.dumps(data), headers=self._get_headers(data))
        response.raise_for_status()
        return response.json()

    def _delete(self, api, data):
        # print("Performing DELETE request agains: {0}".format(api))
        response = requests.delete(self.base_url + api, data=json.dumps(data), headers=self._get_headers(data))
        response.raise_for_status()
        return response.json()

    def send_notification(self, environment, title, message, instruction, app_id = False, user_id = False):
        '''
        Sends a notification to both the LaunchKey Dashboard and the associated user's devices.

        :param environment: String. LaunchKey environment to post to. IE dev, staging, prod (prod is not allowed to be posted to through this API).
        :param title: String. Notification title.
        :param message: String. Notification body.
        :param instruction: Integer. Instruction on how to handle the notification. 0 = Do Nothing, 1 = Refresh, 2 = Push Notification
        :param app_id: Integer. Unique application ID.
        :param user_id: Integer. Unique user ID.

        Note that either a user id or application id MUST be included, but you cannot include both.
        :return: Dict. JSON array containing the results.
        '''
        data = {
            "environment": environment,
            "title": title,
            "message": message,
            "instruction": instruction,
        }

        success = False
        if app_id or user_id:
            if app_id and user_id:
                print("Error! Use only an app id or user id, not both.")
            else:
                if app_id:
                    data['app_id'] = app_id
                else:
                    data['user_id'] = user_id

                success = self._post('notification', data)
        else:
            print("Error! Must include either an app id or user id.")

        return success

    def create_device(self, environment, username, device_name, locale="en"):
        '''
        Creates a new test device.
        :param environment: String. LaunchKey environment to post to. IE dev, staging, prod.
        :param username: String. New user to create.
        :param device_name: String. Device name to associate with the user.
        :param locale: String. Language locale.
        :return: Dict. JSON array containing the results.
        '''
        return self._post('device', {'environment': environment, 'username': username, 'device_name': device_name, 'locale': locale})

    def delete_device(self, environment, username, device_name):
        '''
        Deletes an existing device
        :param environment: String. LaunchKey environment to post to. IE dev, staging, prod.
        :param username: String. New user to create.
        :param device_name: String. Device name to associate with the user.
        :return: Dict. JSON array containing the results.
        '''
        return self._delete('device', {'environment': environment, 'username': username, 'device_name': device_name})

    def authenticate_device(self, environment, username, device_name):
        '''
        Authenticates an existing device that is currently pending approval.
        :param environment: String. LaunchKey environment to post to. IE dev, staging, prod.
        :param username: String. New user to create.
        :param device_name: String. Device name to associate with the user.
        :return: Dict. JSON array containing the results.
        '''
        return self._put('device', {'environment': environment, 'username': username, 'device_name': device_name})

    def deny_device(self, environment, username, device_name):
        '''
        Denies an auth request for a device.
        :param environment: String. LaunchKey environment to post to. IE dev, staging, prod.
        :param username: String. New user to create.
        :param device_name: String. Device name to associate with the user.
        :return: Dict. JSON array containing the results.
        '''
        return self._put('device', {'grant': False, 'environment': environment, 'username': username, 'device_name': device_name})

    def get_devices(self, environment, username, device_name):
        '''
        Retrieves a list of associated devices to a user account.
        :param environment: String. LaunchKey environment to post to. IE dev, staging, prod.
        :param username: String. New user to create.
        :param device_name: String. Device name to associate with the user.
        :return: Dict. JSON array containing the results.
        '''
        return self._get('device', {'action': 'devices', 'environment': environment, 'username': username, 'device_name': device_name})

    def get_device_notifications(self, environment, username, device_name):
        '''
        Retrieves a list of notifications associated with a device (not currently functional).
        :param environment: String. LaunchKey environment to post to. IE dev, staging, prod.
        :param username: String. New user to create.
        :param device_name: String. Device name to associate with the user.
        :return: Dict. JSON array containing the results.
        '''
        return self._get('device', {'action': 'notifications', 'environment': environment, 'username': username, 'device_name': device_name})

    def get_device_logs(self, environment, username, device_name):
        '''
        Retrieves a devices associated logs.
        :param environment: String. LaunchKey environment to post to. IE dev, staging, prod.
        :param username: String. New user to create.
        :param device_name: String. Device name to associate with the user.
        :return: Dict. JSON array containing the results.
        '''
        return self._get('device', {'action': 'logs', 'environment': environment, 'username': username, 'device_name': device_name})

    def authorize(self, environment, username, app_key, whitelabel="False", all=0, knowledge=False, inherence=False, possession=False, locations=None, context=None):
        '''
        Sends an auth request for a device.
        :param environment: String. LaunchKey environment to post to. dev, staging, prod.
        :param username: String. Username to receive auth request
        :param app_key: Optional. If specified, uses that app to authorize
        :param whitelabel: Boolean
        :param all: Integer. Number of factors to require. Cannot be > 0 if #knowledge, #inherence, or #possession is True
        :param knowledge: Boolean. Require a knowledge factor. Cannot be True if #all is greater than 0
        :param inherence: Boolean. Require an inherence factor. Cannot be True if #all is greater than 0
        :param possession: Boolean. Require a possession factor. Cannot be True if #all is greater than 0
        :param locations: JSON string containing an array of of objects containing radius, latitude, and longitude
        attributes, i.e. '[{"radius": 100, "latitude": 12.34, "longitude": 23.45}]'
        :return: Dict. JSON array containing the results.
        '''
        data = {'environment': environment, 'username': username, 'appkey': app_key, 'whitelabel': whitelabel}
        if all > 0: data['all'] = all
        if knowledge: data['knowledge'] = knowledge
        if inherence: data['inherence'] = inherence
        if possession: data['possession'] = possession
        if locations: data['locations'] = locations
        if context: data['context'] = context
        result = self._post('auth', data)
        if 'auth_request' in result:
            return result['auth_request']
        else:
            return result

    def is_authorized(self, environment, app_key, auth_request, whitelabel="False"):
        '''
        Queries the status of a given auth request (combines poll and is_authorized)
        :param environment: String. LaunchKey environment to post to. dev, staging, prod.
        :param username: String. Username to receive auth request
        :param app_key: Optional. If specified, uses that app to authorize
        :param whitelabel: Boolean
        :return: Dict. JSON array containing the results.
        '''
        poll_response = self._get('poll', {'environment': environment, 'auth_request': auth_request, 'appkey': app_key, 'whitelabel': whitelabel})
        if poll_response['success']:
            return self._get('log', {'environment': environment, 'auth_request': auth_request, 'appkey': app_key, 'whitelabel': whitelabel, 'auth': poll_response['auth']})
        else:
            return {"success": False, "message": "no response"}


    def create_whitelabel_user(self, environment, username, app_key):
        '''
        Sends whitelabel user creation request to get needed code
        :param environment: String. LaunchKey environment to post to. dev, staging, prod.
        :param username: String. Identifier to be paired.
        :param app_key: app_id for a whitelabel
        :return: Dict. JSON array containing the results.
        '''
        response = self._post('user', {'environment': environment, 'identifier': username, 'appkey': app_key})
        if response and 'code' in response:
            return response['code']
        else:
            raise Exception("Error creating user: {0}".format(response))

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description='Client to query against LaunchKey Admin Panel API')
    parser.add_argument('method', help='Function to query (create, delete, auth, logs, authorize, deny, authorized')
    parser.add_argument('--env', default="staging", help='LaunchKey Environment to query (prod, staging, etc...)')
    parser.add_argument('--locale', default="en", help='Locale of user (defaults to en)')
    parser.add_argument('--username', default="", help='User to query')
    parser.add_argument('--device', default="", help='Device name to query')
    parser.add_argument('--appkey', default="", help='Application key to authorize')
    parser.add_argument('--whitelabel', default="False", help='Whether whitelabel is being used')
    parser.add_argument('--authrequest', default="", help='Auth request value')
    parser.add_argument('--policy-all', type=int, default=None,
                        help='Number of factors to require. Cannot be used in conjunction with --policy-knowledge,' +
                             ' --policy-inherence, or --policy-possession')
    parser.add_argument('--policy-knowledge', default=False, action='store_const', const=True,
                        help='Require a knowledge factor. Cannot be used in conjunction with --policy-all')
    parser.add_argument('--policy-inherence', default=False, action='store_const', const=True,
                        help='Require an inherence factor. Cannot be used in conjunction with --policy-all')
    parser.add_argument('--policy-possession', default=False, action='store_const', const=True,
                        help='Require a possession factor. Cannot be used in conjunction with --policy-all')
    parser.add_argument('--policy-locations', default=None,
                        help='JSON string containing an array of objects containing radius, latitude, and ' +
                             'longitude attributes, i.e. \'[{"radius":100,"latitude":12.34,"longitude":23.45}]\'.' +
                             ' Due to argument parsing restrictions, keep spaces out of your JSON string.')
    parser.add_argument('--auth-context', default=None,
                        help='Context value to be passed to authentication request. It cannot contain spaces')

    panel = AdminPanelAPI()

    args = parser.parse_args()

    if args.method == 'create':
        success = panel.create_device(args.env, args.username, args.device)
    elif args.method == 'auth':
        success = panel.authorize(args.env, args.username, args.appkey, args.whitelabel, args.policy_all,
                                  args.policy_knowledge, args.policy_inherence, args.policy_possession,
                                  args.policy_locations, args.auth_context)
    elif args.method == 'authorize':
        success = panel.authenticate_device(args.env, args.username, args.device)
    elif args.method == 'authorized':
        success = panel.is_authorized(args.env, args.appkey, args.authrequest, args.whitelabel)
    elif args.method == 'logs':
        success = panel.get_device_logs(args.env, args.username, args.device)
    elif args.method == 'delete':
        success = panel.delete_device(args.env, args.username, args.device)
    elif args.method == 'deny':
        success = panel.deny_device(args.env, args.username, args.device)
    elif args.method == 'create_whitelabel_user':
        success = panel.create_whitelabel_user(args.env, args.username, args.appkey)
    else:
        success = "No valid method specified"

    print(success)