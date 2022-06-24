function multiselect(labels,M, nameGUI)

flag = false;
fig = uifigure('Name',nameGUI);
checkNameSM = "State Machine";
TF = contains(nameGUI,checkNameSM); % flag true if substring contained in nameGUI

lblX = uilabel(fig);
lblX.Text = 'X-Axis';
lblX.Position = [430 330 100 22];

lblY = uilabel(fig);
lblY.Text = 'Y-Axis';
lblY.Position = [430 245 100 22];

pan = uipanel(fig,'Position',[10 10 400 400]);
ax = uiaxes('Parent',pan,...
    'Position',[10 10 390 390], 'XGrid', 'on', 'YGrid', 'on');

ax.Title.String = 'Telemetry';
ax.Title.FontWeight = 'normal';


% ax.XLabel.String = 'time [s]';
% ax.YLabel.FontSize = 12;

axtoolbar(ax,{'export','pan','zoomin','zoomout','restoreview'});
ax.Interactions = [zoomInteraction panInteraction dataTipInteraction];

x = M(:,1);
y(:,1) = M(:,2);

if TF
    stem(ax,x,y(:,1),'LineWidth',1);
else
    plot(ax,x,y(:,1),'LineWidth',1);
end

hold(ax,'on')


% % Create Text Area
% txt = uitextarea(fig,...
%     'Position',[125 80 100 50]);

% Create List Box
lbox = uilistbox(fig,...
    'Position',[430 100 100 140],...
    'Items',labels(2:end),...
    'Value',labels(2),...
    'Multiselect','on',...
    'ValueChangedFcn',@selection);

dd = uidropdown(fig,...
    'Position',[430 300 100 22],...
    'Items',labels(1:end),...
    'Value',labels(1),...
    'ValueChangedFcn',@selection);

% Create ValueChangedFcn callback:
    function selection(src,event)
        cla(ax);
        valx = dd.Value;
        posx = find(strcmp(labels,valx));
        x = M(:,posx);
        
        valy = lbox.Value;
        
        for i=1:length(valy)
            posy(i) = find(strcmp(labels,valy(i)));
            temp(i) = labels(posy(i));
            y = M(:,posy(i));
            if TF
                stem(ax,x,y,'LineWidth',1);
            else
                plot(ax,x,y,'LineWidth',1);
            end
            if length(valy)>1
                leg = legend(ax,temp,'Location','SouthEast','Interpreter', 'none');
            else
                leg = legend(ax,'hide');
            end
            hold(ax,'on')
            
        end
        
        
        if flag
            hf=findobj('Type','figure');
            close(hf)
            flag = false;
        end
        if size(temp,2)>1
            flag = true;
            f = figure;
            f.Name = ['Stacked',' ',nameGUI];
            f.WindowState = 'minimized';
            y_stack = M(:,posy(:));
            stackedplot(x,y_stack,'LineWidth',1,'GridVisible','on','Title','Stacked Telemetry',...
                'DisplayLabels',temp);
        end
        
        axtoolbar(ax,{'export','pan','zoomin','zoomout','restoreview'});
    end

end
