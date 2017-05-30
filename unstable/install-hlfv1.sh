(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� -9-Y �]ks�J�ޟ���e�$�oS5U��)*(�(�:���APQ���dr�\�$��5<SHw�4��׳Vgu��d_��2���__� M��+J�����Bq�1�@Т����F~Msc����V�k���i�r�����p�?������rz���x�}ʈ�\�M�����[�MAe \,!0��x���7T��%	���P�w���+���p��	�������?���:N�7���'i��_��k�;�2�L��/z�Q�A����P�أ���(I����w�O�x�Z��������O#��9��`���M����4��됄�{.�P������4E2�k;E�(����}�ث�:ʐ�i�Sċ�'���/>��UC��?\�_��Y������.��km�:�AJ��&���ĻlR_�L~o�Q�k�VCٴ��MfBj��|����F_!X�b3h�q<u��ؤ������D�)�F=D!���t��S�N'[	��n C�T��>am�}yq �HqՏl���_�k߿C�Ɗ���k�������Eӥ������?
#���R�Y�˸:�z��уg���QǞ���)x��yQ7dI��y��e�o<�nr���)K�Of}o�9�5��E����p5�Ϻ=M��-�!^�S�b�2�P�t ���0)�����e�C��Ny�NQ����������3� �
`��(��0�ݏ�N4@�U���7��x�깑�S8b	��+��+���B3	�\��{�p��[��Q��܂���@��5�?W'Nc9xkcŝ4�s�kf�7�n$m,lq�0�U�����\�O�"��$ͽ������Nip�3m�P<Q(t���P�ȀS}U���ÛC����F�v#a����+6F�L��~�A�ڀv�,g%�U.܎Pޕ��e��(nugJ7s-j6:p����{B.rp��G�'3�;�A�_�� \����4<�\XR����G��H��eQV���I9h�71��oVL�̖�Q��@���Fc$J�Ms�<0
Q� 	�"xY����Ɂ\&�$�H�Kqc6˨�9�v��oX���[NҖ�FSŋQW2Y1��@�E#�3�^<�F�.����lx6���Y~I�g�����G���K�'��Q�S�M�G��?�D��e�-�g�;���@=2̛흺_���@�8��В��X>̐#q���^B������
|Hʑ�z E�����di���2s��I���:?�2��4]�!�l��b��p��#v�D���[�NyM1GkH���5q"5q1u{�����h�yl��W�y.�V��
������2t����[���˶:U �U��ք9P�m�0<Z GZoi�rf�m qy���+ ���TɌ�\�A����}� ����堛��>�u�^��[��kSR�G�D������:��u�E��`f����d_��8�#�f5�7�~�&��� 7ؽߤی�	��97�~&׵d:\M�6��C%�u���|����]�������d�Q
>E��9�}��G(���T���W���k���wL���_x�D��e������?��W
���*����?�St������f�������); 	h�e0�u(��%�q�#�*��B����Y�E`��W.����=q�w4)h��Hc=A]f��\�������F��/���ec�m+��qCN���o�|�-[ʰ�l��a��%ǜ�L7�t;��=�csc����
p;�nX@�$�m��=�������W��T��������?8MW��T���_��W��}H�e�O�������(�S�*���/�gz����C��!|��l����;�f���w�бY��G�Ǧ��|h ���N���p\�� ��I��!&��{SinM�	����0w�s��t��$��P�s��m6�7�y�ֻ� 
�4%
��<.&�R��;Y�c���'Zט#m�G��lp�H:����9:'�8���c� N��9`H΁ ҳm��-LC^���Νp�n��3Զ��$tpaA�ܠ�w�=Ο��={2hBU'���F�����z�_@�I���u���N�,�Ҳ��h�����j*8���1���Y��e�$d��9Ɋ�����O�K��+���������+�*�/��_�������������#�.�A+�/�����?F������+��������!���Z� U�_���=�&�p�Q��Ѐ�	�`h׷4�0�u=7pqaX%a	�gQ�%Iʮ��~?�!����� +��\��2aW�W���X�plNl����{���6[�A�z�^��C	��yܩ�JJ�E�Il/��j����hc7�1c���������<D i�l0h�C���<�甒S�ݬ���0��8���ӏ����G��_���������S�?��CU����{�R�\�8AW�|T�oo_V�˟�1���L����b��t�����?�>��IW�?e�K�?K#t�������6�26�R��Q��,��x4B��x���o���BQi(C���������j���q��O���>H-�j7���X&��\=V�k��������Հ&\xٮ��sX]W|.E�T�;��ͣ�L8�u>ʼf$���-�?����!�V�g"�	���� ����֫���3��K�A?`�T�������CI��G!xe���/���/��P&ʐ��J�O�	�������>�y���;b%�A�*�5��`�����������п?�c�ㆹ�T��bxT�޺��p#s���s�֣s�����?z4��i�M;�L(�|�#�S:E_̋W�m;��^�$��}�؄q��1r-��f��Ex�p�LNp�ɬ'��x��bs5�9jo�EsI�٠��`�uF9��z��2<�Q&�=b��Mb����k�Mba΅�x��9ޭ�+�F��5a��7�STY�M9�S�Kw*�vg<6� n-�y��<�K�In{.���}�?�� �'�)gSs��wu��{
mE6��l�q�s�2�)a�l�i��@�=��a�Sb3�=)�h���g�O�֪�Ys�P��ϋ�L���v���8^���෰�)����!|���In���(C�o����(Y��^
޷����c��_��n�$��T�wx��#�����2?yf(?��G�t���@�O��@q[z-PS �]��'n��k�r��@���Nu7%�},mQI�����z�6�}�VzjJ���[3�c�҄�!��fL�9M���Tnx@A����㤯&��΃����� ��>t�����d��As�j$Z���ټK��i�^)�y�HVs��{�)��a���3[���Z����A{��h؄�=����O�y��S|���8����&���R�[�����j�OI���_-��{P��?��OU�������j��Z�����)0��X����K���ܺ���1
����RP��������[��P�������J���Ox�M���(�8�.C�F��O�L�8��C�O��#��b��`xu
�o�2�������_H�Z�)��J˔l99�[�Ԍa��"4����V�X�<�-j���c�鸭��+�{ɚ�zb��vp�*�(�9����Q���w-���3�(C�Sez��RGYl�C�j��G����O��%q�_���?��������/�T��U
�~�Z�[�o�o��t;u��T��6r��j���o��>�Ӆ��tl'��W��m�P7q�^#�ȕ�H&��3�r;M�e�/��Jj���8]�oxp��*�w�_��Ok�:��OOL�t����?4Bߎ?�sJ+nd/�o�lR�rk?��v�vU�\W+��¯���'��X�8W4�����	'�ծ��i�ŷ��$��v坺`/6������KNu��޷����ڞ.��fiGŨp훻ʠ����p;r���}cX��hluuA�E��!��:7�o�*]���#ק/�>^�r_�fW�~��[E%��|��^�q������\;�BϾ��.:J�'߻���YZ���-����`{��ӿ)���Żڋ��=��e҂H�?m��7����3�պ8կWv7�^�M�v�����U�������c�_m�\T{X��OM��t>]�7�4�V��d�qb�'p��p8]O6�u��~2�I�^�=L|�	�!�3%pVϧ�� }T�3����Gd��S7�\=�����2)���7|�*��q$�C4dE�����y\VG��u��'�J1g�^WV���t���I��᭝��f	�-����D?}�'����]m��d���rx.\%�� �1����뺗�u�麭{ߔ\{���֭=�މ	jBL0�%h�$h�����~R�4��H���#
1Q?�m��lg�9;����M�����ҧ��������<�i����%��d:c�lr�rSn%d"v���D2A�")<]F;�Y#�L&���LG�a\��e혀��I��,/L��p:�ǭ��7�r`��ѱ��b 6t/��5 h��s�3�ۄ�J�ńq!v�E�Q�%I������v��k�&��u#��
�k�Cn��4�0�Rt�kq���3V3EL<�d�v[�t�ԵQ�w����|x�Y����P�����&3ّ鶐-$��[�'�%��*|��H�w�w�8g܄�e���_3�\We�ДF�#!2�R��8�.�F�j�5�w���Bi1^2f^�[��[7gyQc4E��)��F�E�E�e�6��Q�ti&Nm8=�����_�S�;��ɉ����4�b|�\]������iU��=�s�g�w�yN��S�9�uPK�!ˠ�Hҩ��#U��q���YG�S���=�Re�EXs�7#�ˈ�H���׌�����|t�D��8��U���.s�fGW���u�q�]d��SyV��R�6y����U�.r�\�lQ�I�Z;[3o u��j����g��d&/G��O�����g�uT�h��*�7V�x�s.���=��k�n���4m&?�t눅��8/��f��8��ˈ	���91�{�*���v.����7��Z��|WW�%�Ѕ����÷9Z���������3w��T��WU�1�p�i�捣�����#`>��&�m�߭:����F��f��������w?�W��!PX;�qj��?���Z*q�m����<�j �S��ȶ�W�~ԍm{Y�^϶�Zu�� Ώp��r���������g~��c�V3�=��o�_~�k����W(�v+�x��~�׌�����w��^�s�G��U��3�o���87s��' 59cS��xS��~qS�#0��)n^�gq�������"���\���zt��K�x�s��:^��'���Z�����o����.�6�����۰;�(���`� G�~�t�9!"om��Wh3�B��^����\?_%w����|q�G�L=_N�s��[��K����6'�Ka�ȳ�Nw���)%�
G{����4�����b=�DY|"�H��[�(�2�젯d����"R��ճ�%���(W���������\
Jj��жJ�*S,����RS
��z���`���z��̈́���6v&,���2��a�S�z�km�	����-5C��֞�+!�V5���֢隒��� ��U�O2Ii�M��\=.�}-�x��&��\�D�����	�w$�3a2�p��	�CYIf�a�H�����P;�a���O�sȺGxFv�`Y�Nd&h?�U�C��Z-+�]����O�"M�i^�Ɓ�a�4W�4��g���f"X���!�h�����Ϗ1�}��|��%|Lʲd�e�rg6s�)��Rܷé���;���4�
H��#Т��Z�p>�!��,��WB�0VL��&,�)��VZ��++�*hnS�S���V��.����i����LKJ�)��٥�U=x�W�iߐ$�.�[V�4�]�HT�z��&-∩,�a����D��B�*����H�ɔ�B5���b��*.���[�,����_Y�+(K��x�B�
�GI��g�����&���j��v��~%��-�0԰�ƕhQ��ɵ�J�����#1��&��pNY�b�&�܋������r�3e�A�e����ReaB��w��������PR���t��5�r�l�M�}� �o6$u�G$�ZS�ڄ��y
u�P�d�"[� ��ۓ,v�~��}6�g�}��|��S��Ӝ(����ڼ�A�έ]	m@k�)�+6�@�M�J[�<`|]����Sy֡3�y֯��*ͳ�CU�q�.ȶ9��˝6t#t���u55K�np�Py�sPJ�j� �	�܀s��qI�ܸ�D�b
i^k�5��MUu=���[ZG�Z�N���,ɖ�\k�&S�����5�����!g~�aݦ�ꜳЙ�� 0��~� n�<+�*fˡ[��u�k��1U��m���Ĵ��).+z�<8�+���
�9��3�=m �@�e��x�AN�, �j3����r���ou�#7�"/o�Co�C[�-�~)�_
V~)x���{��`�Zx�n��R�T�X!H�pw˳��[xP8��-u$D�RGc��pv4h��F��5�=E�ꂃ�=Np�'���1ݬ)����A�=`� |"���w�Ԧ��I��a#
a�@e�HqKK4�C�G�!$��z/@r^!�E���SʣyݹM��ƕ|��0X�q��ʡ�=8T�x
��{>�G�B�8��Ocb<$��Cv���5I�� �Q�7��w����J1���H��0�K����>�H������RPQ�ٰi�.Ε��5�0������>Ջ	���n���T׺��) �ԡ���L�jZ������ᴍ�6�8�c]�^���m�Sy˔sy���Ǝ�t��ϴb������o��p=t�ʰ��N<,���{���'���?����r_ˎ�}p"i�"����(�+I���U.�D똗`s
d���Gv�T,E�:΃Ճ"�LPdG�LZFA��fMYVz<�-\��C��$01������H2�#b;�qj�@����A�`J�G�.
@��tI��(����rw��(�.�$��	�ha:�7ٍ���v�n�ÄH�-5�vԳ����<9$�J�m�>�|ig p�X������WJU�$/�a�g�B��Q?��]ْ��wxX[�\ �dI^+�K�H��M�Z�D
�.����e�m�o�q(��=�[�)s�)�ɱB�k���
a����V3lb�l���ZKȴ���f�p�?z�aJ|}��+��4^�{�p���?�ǅ� � 6!Z�2Q���w@p�^�{.�j4I'����{X̮W��[���4B�����z��w}饿<��ǡk��@X��v�k���f���\ǁ�OԻw����^���g���O��/�q�ǿ�t���7=�͛���_M����������8�N���kWx��+�+z��k��D�
��}#��+?��g����t�g�����_�Ƈ��^��k�G
����'��,��U��iS;mj�M�i6�����~��k�퀴M����6����l���@�<4��2�A/�T�
��F�a��`��ݶ�:�x��c��31t������?qzm���"d�l���؟R�O�6��6�8�3��8�G`\2��|�65�f��eϙ�����{Z�=-��3c�m�a����a
�嘙s��p���J�|wɣ�H�<.~��Ak���?;��Nv���6��jy  