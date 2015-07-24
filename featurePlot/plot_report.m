function plot_report(res)
import mlreportgen.dom.*;
doc = Document('./plot_report.pdf','pdf');
% for a layer
for ly = 1:numel(res)
    % skip if the dimension is 1*1
    if size(res(ly).x,1) == 1 && size(res(ly).x, 2) == 1
        continue;
    end
    % determine the range of pixels, used for normalization later on
    % pixel_range = max(max(max(res(ly).x))) - min(min(min(res(ly).x)));
    % create a paragraph
    para = Paragraph();
    for imno = 1:size(res(ly).x,3)
        % convert the images to ImageObj
        [~, filename] = simplenn_plot(res,ly,imno,true);
        saveas(gcf,filename);
        myImgObj = Image(filename);
        % append the ImageObj to the paragraph
        para.append(myImgObj);
    end
    % append paragraph to document
    doc.append(para);
end

%close the document
close(doc);