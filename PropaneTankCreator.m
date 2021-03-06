disp('Y_i200513_Ammar Y_i200830_Salar')
disp('This Program was developed by Salar&Ammar Advisors inc.')
disp('Hello and welcome to Make Your Propane Tank')
disp('This Program will tell you the best way to make a capsule shaped propane tank with the least amount of money!')
disp('Simply enter : ')
disp('1 the amount it costs you to make end peices of the tank')
disp('2 the amount it costs you to make the cylindrical part')
disp('3 the volume you want the tank to be')
input('Press enter to continue') %this simply lets the user press enter to continue to the program
choice='y';
while(choice~='n')      %the code will loop till the user wants to stop making more tanks
    %dimension saves the dimension of length being used
    unit=input('What unit are you using? (ft / cm / m) = ','s');
    %hemi saves the value of the cost of making the sides of the tank (which are hemispherical in this case) input by the user
    ends_cost=input('Enter what it costs you to make the end parts (per unnit square) = ');
    %cyl saves the value of the cost of making the cylindrical part of tank
    cyl_cost=input('Enter what it costs you to make one of the cylindrical part (per unit square) = ');
    %volume saves the desired volume needed by user
    volume=input('Enter the volume you want to obtain = ');
    
    %r and l are symbolic variables used to solve the equations of volume
    %and surface area
    syms r l
    %volume of cylinder is declared as it is (pi x radius^2 * height)
    volume_of_cylinder=pi*(r^2)*l;
    %volume of spherer is declared as what the volume of a sphere would
    %produce (4/3 x pi x radius^3)
    %the reason why we are taking volume of sphere is because the two
    %hemisperes at the end will add up to make one sphere
    volume_of_sphere=(4/3)*pi*r^3;
    %here the expression for total volume is made up
    total_volume=volume_of_cylinder+volume_of_sphere;
    
    %here, the expression for length is made with respect to r, making h
    %the subject where the total volume expression formed above is equal to the desired volume of the user 
    length=solve(total_volume==(volume),l);

    
    %here a function is made of cost and radius ( cost(r) )
    %the cost depends on the area of the tank, more specifically:
    %the area of cylinder mulitplied by its contribution to cost
    %and
    %the area of the hemispheres multiplied by their contribution
    cost=ends_cost*(4*pi*(r^2))+cyl_cost*(2*pi*r*length);

    %here, the TRUE magic happens
    %diff is a function which finds cost'(r) and stores it in dC_dr
    dC_dr=diff(cost,r);
    
    %the roots of dC_dr are found so we can find the minimum of the cost
    %all the possible (even non-real) roots are stored in roots_for_dC_dr
    roots_for_dC_dr=solve(dC_dr==0,r);
    %here, logical indexing is being done to fetch the real root (whether
    %it is negative or positive)
    idx=abs(imag(roots_for_dC_dr))<eps;
    real_root=real(roots_for_dC_dr(idx));
    %it is checked using the if statement if the smalest possible value for
    %radius is negative or not. (it is possibly negative if the cost of manufacture for the end pieces is set to be smaller than the price of the cylinderical part) 
    %using if, the value for radius is converted to positive if needed
    if(real_root<0)
        solution_for_radius=vpa(real_root*-1);
    else
        solution_for_radius=vpa(real_root);
    end
    
    
    %length was initially an expression of r
    %using subs() we substitute the valye of r with real_root which is the
    %required radius, and use vpa() to form the rational number into a
    %decimal number, understandable by the user
    solution_for_length=vpa(subs(length,r,solution_for_radius));
    
   
    %three symbolic functions are declared x,y,z
    %a cylinder function is created which is a function of x,y,z
    %by nature, the original formula created was to actually form a sphere
    %which is x^2 + y^2 + z^2 = r^2 where r is the radius of sphere
    %this modified equation simply takes the two hemispheres of a sphere
    %and stretches them outward, creating a cylinder in between
    %the modified equation is 
    %x^2 + y^2 + 1/4(|z-(L/2)|+|z+(L/2)|-2L)^2 = r^2
    %where, L is the length of the cylinderical bit you want in the middle
    %in the function below, x has been swapped with z for better
    %orientation when displaying the interactive figure of the tank
    %and since matlab does not offer |X| functions
    %the value is first squared and then squarerooted so only positive
    %solutions are presented
    syms x y z
    cylinder= z^2 + y^2 + 1/4*( sqrt((x-(solution_for_length/2))^2) + sqrt((x+(solution_for_length/2))^2) - 2*(solution_for_length/2) )^2 - solution_for_radius^2;

    
    %all the outputs are done after here
    
        %here all the graphs that might be needed by the user are ploted and
        %will be desplayed with useful information
        figure(1)
        fplot(length)   %plots graph of length with respect to change in radius
        xlim([0 10])
        title('plot of length of cylinder with respect to radius')
        xlabel('radius')
        ylabel('length')
        grid on
    
        figure(2)
        fplot(cost,'r')   %plots cost(r)
        title('Change in cost with respect to radius (in red) and rate of change of cost with respect to radius (blue)')
        hold on  %hold on so the graph of cost(r) and cost`(r) are on the same figure
        fplot(dC_dr,'b')    %plots cost'(r) on the same figure
        legend('cost(r)','cost`(r)')
        xlabel('radius')
        ylabel('cost')
        xlim([0 10])
        grid on
        hold off  %hold off so the next time this figure is printed, the privious plots are not shown
        
        figure(3)
        fs=fimplicit3(cylinder);   %the cylinder function is made a 3 dimensional implicit function and saved in another variable so changes can be made into it
        fs.MeshDensity=60;
        title('interactive shape of the tank created')
        xlabel(unit)
        ylabel(unit)
        zlabel(unit)
        
        %here, the cost is being calculated by substituting the value of
        %radius caluclated into the cost(r) function
        final_cost=vpa(subs(cost,r,solution_for_radius));
        
        
        disp('optimum radius in the definded units : ')
        disp(solution_for_radius)   %printing the final optimal solution for radius
        disp('optimum length of cylinder in the defined units = ')
        disp(solution_for_length)   %printing the final optimal solution for length of cylinder
        disp('it will cost you: ')
        disp(final_cost)            %printing the final cost of making the tank
   
        
    
    
    choice=input('Do you want to create a new tank with different inputs? (Enter "y" for yes / "n" for no) = ','s');    %user makes choice
    while~(choice=='n'||choice=='y')    %choice validated by this loop
        choice=input('Invalid entry, re-enter (Enter "y" for yes / "n" for no) = ','s');
    end
end
