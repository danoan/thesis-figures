var basePath;

function build_path()
{
    var r=document.getElementsByClassName("row")[0];
    var l=r.children.length;
    var relPath="";
    for(var i=0;i<l;i++)
    {
        var c=r.children[i];
        var buttons=c.children[0].children;
        for(var j=0;j<buttons.length;j++)
        {
            if(buttons[j].classList.contains("selected"))
            {
                if( buttons[j].hasAttribute("path") )
                {
                    relPath = relPath.concat(buttons[j].getAttribute("path"), "/");
                }
            }
        }
    }

    return relPath;
}

function get_current_display()
{
    var display = document.getElementsByClassName("display")[0];
    for(var i=0;i<display.children.length;++i)
    {
        if(display.children[i].classList.contains("active"))
        {
            return display.children[i];
        }
    }
}

function get_active_subdisplay(display_class)
{
    var activeDisplay = get_current_display();
    var subdisplays = activeDisplay.children;
    for(var i=0;i<subdisplays.length;++i)
    {
        if(subdisplays[i].classList.contains(display_class))
        {
            return subdisplays[i];
        }
    }
}

function load_figure()
{
    var relPath=build_path();

    var flipflow_seg_img = basePath.concat("/flipseg/",relPath,"corrected-seg.png");
    var flipflow_seg = get_active_subdisplay("flipseg");
    flipflow_seg.children[0].setAttribute("src",flipflow_seg_img);

    var balanceflow_seg_img = basePath.concat("/balanceseg/",relPath,"corrected-seg.png");
    var balanceflow_seg = get_active_subdisplay("balanceseg");
    balanceflow_seg.children[0].setAttribute("src",balanceflow_seg_img);

    var graphflow_seg_img = basePath.concat("/graphseg/",relPath,"corrected-seg.png");
    var graphflow_seg = get_active_subdisplay("graphseg");
    graphflow_seg.children[0].setAttribute("src",graphflow_seg_img);
}


function select(el)
{
    _select(el,true);
}

function _select(el,load_flag)
{
    var list_li=el.parentElement.children;
    for (var i=0;i<list_li.length;i++)
    {
        if(list_li[i].hasAttribute("type"))
        {
            list_li[i].className="button";
        }

    }
    el.className="button selected";
    if(load_flag)
    {
        load_figure();
    }

}

function default_buttons()
{
    var r=document.getElementsByClassName("row")[0];
    var l=r.children.length;
    for(var i=0;i<l;i++)
    {
        var c=r.children[i];
        if(c.hasAttribute("menu"))
        {
            var buttons = c.children[0].children;
            var first = buttons[1];
            _select(first, true);
        }
    }
}

function open_src(el)
{
    document.location.href=el.getAttribute("src");
}

function init()
{
    basePath=window.prompt("Enter images base folder");
    if(basePath=="")
    {
        basePath=window.location.toString();
        basePath=basePath.substring(0, basePath.lastIndexOf("/") );
    }else
    {
        basePath="file://".concat(basePath);
    }
    default_buttons();
    load_figure();
    document.body.style.visibility="visible";

}


window.onload=init;