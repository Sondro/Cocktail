package core.boxmodel;

import haxe.ds.Option;

import buddy.*;
using buddy.Should;
import utest.*;

import cocktail.core.boxmodel2.BoxModel;

class BoxModelTest extends BuddySuite {

    public function new() {
        describe('BoxModel', function () {
            describe('getComputedPadding', function () {
                it('computes absolute length padding', function () {
                    BoxModel.getComputedPadding(AbsoluteLength(50), 100)
                    .should.be(50);
                });

                it('computes percent padding', function () {
                    BoxModel.getComputedPadding(Percent(20), 100)
                    .should.be(20);
                });
            });

            describe('getComputedConstrainedDimension', function () {
                it('computes absolute length constraint', function () {
                    var ret = BoxModel.getComputedConstrainedDimension(AbsoluteLength(50), 100, false);
                    Assert.same(Some(50), ret);
                });

                describe('percent constraint', function () {
                    it('computes percent constraint', function () {
                        var ret = BoxModel.getComputedConstrainedDimension(Percent(20), 100, false);
                        Assert.same(ret, Some(20));
                    });

                    it('uses empty value if container is auto', function () {
                        var ret:Option<Int> = BoxModel.getComputedConstrainedDimension(Percent(50), 100, true);
                        Assert.same(None, ret);

                        var ret2:Option<Int> = BoxModel.getComputedConstrainedDimension(Percent(50), 100, true);
                        Assert.same(None, ret2);
                    });

                    it('uses empty value if there are no constraints', function () {
                        var ret = BoxModel.getComputedConstrainedDimension(Unconstrained, 100, true);
                        Assert.same(ret, None);
                    });
                });
            });

            describe('constrainWidth', function () {
              it('constraints a width to its max width', function () {
                BoxModel.constrainWidth(200, Some(100), None)
                .should.be(100);
              });

              it('constraints a width to its min width', function () {
                BoxModel.constrainWidth(100, None, Some(200))
                .should.be(200);
              });
            });

            describe('getComputedMargin', function () {
              describe('Percent', function () {
                it('has no margin if width is auto', function () {
                  BoxModel.getComputedMargin(Percent(50), Auto, 100, 50, true, 50, true)
                  .should.be(0);
                });
              });
            });

            describe('getComputedAutoMargin', function () {
              it('has no margin if it is a vertical margin', function () {
                BoxModel.getComputedAutoMargin(Auto, 100, 100, false, 0, false)
                .should.be(0);
              });

              it('has no margin if the width is auto', function () {
                BoxModel.getComputedAutoMargin(Auto, 100, 100, true, 0, true)
                .should.be(0);
              });

              it('takes half the remaining container space if the opposite margin is auto', function () {
                BoxModel.getComputedAutoMargin(Auto, 200, 100, false, 50, true)
                .should.be(25);
              });

              it('takes the remaining container space after the opposite margin value is known', function () {
                BoxModel.getComputedAutoMargin(AbsoluteLength(20), 200, 100, false, 50, true)
                .should.be(30);
              });
            });
        });
    }
}
