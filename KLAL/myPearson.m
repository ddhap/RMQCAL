function coeff = myPearson(X , Y)
% ������ʵ����Ƥ��ѷ���ϵ���ļ������
%
% ���룺
%   X���������ֵ����
%   Y���������ֵ����
%
% �����
%   coeff������������ֵ����X��Y�����ϵ��
%


if length(X) ~= length(Y)
    error('������ֵ���е�ά�������');
    return;
end

fenzi = sum(X .* Y) - (sum(X) * sum(Y)) / length(X);
fenmu = sqrt((sum(X .^2) - sum(X)^2 / length(X)) * (sum(Y .^2) - sum(Y)^2 / length(X)));
coeff = fenzi / fenmu;

end %����myPearson����